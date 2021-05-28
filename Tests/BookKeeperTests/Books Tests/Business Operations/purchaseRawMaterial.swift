import XCTest
import BookKeeper

extension Dictionary where Key == RawMaterial.ID,
                           Value == RawMaterial {
    func hasZeroInventory() -> Bool {
        totalBalance(for: \.inventory) == 0
    }
}

extension BooksTests {
    func testPurchaseRawMaterial() throws {
        var books: Books = .init()
        XCTAssert(books.rawMaterials.hasZeroInventory())
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)

        // try purchase
        let order: PurchaseOrder = .sample
        XCTAssertThrowsError(
            try books.purchaseRawMaterial(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownRawMaterial)
        }

        // confirm no change after error
        XCTAssert(books.rawMaterials.isEmpty)
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)

        // add raw material and try purchase
        books.add(rawMaterial: .sample)
        XCTAssertThrowsError(
            try books.purchaseRawMaterial(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.rawMaterials.hasZeroInventory())
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)

        // add supplier and try purchase
        books.add(supplier: .sample)
        XCTAssertNoThrow(
            try books.purchaseRawMaterial(for: order)
        )

        // confirm change
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(
            books.rawMaterials.totalBalance(for: \.inventory),
            order.amountExVAT
        )

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(
            // books.suppliers.combined(\.payables).balance(),
            books.suppliers.totalBalance(for: \.payables),
            order.amountWithVAT
        )

        XCTAssertEqual(books.vatReceivable.balance,
                       order.vat)
    }
}
