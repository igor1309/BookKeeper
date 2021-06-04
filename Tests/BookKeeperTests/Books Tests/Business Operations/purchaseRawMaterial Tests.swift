import XCTest
import BookKeeper

extension BooksTests {
    #warning("test passes but not confirming everything here - check all elements that could change")

    func testPurchaseRawMaterialUnknownRawMaterialError() {
        #warning("should purchaseRawMaterial create rawMaterial and add it to books?")
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // try purchase
        let order: PurchaseOrder = .sample
        XCTAssertThrowsError(
            try books.purchaseRawMaterial(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownRawMaterial)
        }

        // confirm no change after error
        XCTAssert(books.isEmpty)
    }

    func testPurchaseRawMaterialUnknownSupplierError() {
        #warning("should purchaseRawMaterial create Supplier and add it to books?")
        // create books with raw materials
        var books: Books = .init(rawMaterials: .sample)

        // confirm
        XCTAssert(books.suppliers.isEmpty)
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(Array(books.rawMaterials.values), [.sample])
        XCTAssertEqual(books.rawMaterials.totalBalance(for: \.inventory), 37_555)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 37_555)

        // try purchase
        let order: PurchaseOrder = .sample
        XCTAssertThrowsError(
            try books.purchaseRawMaterial(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.suppliers.isEmpty)
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(Array(books.rawMaterials.values), [.sample])
        XCTAssertEqual(books.rawMaterials.totalBalance(for: \.inventory), 37_555)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 37_555)
    }

    func testPurchaseRawMaterialNoErrors() {
        // create books with raw material and supplier
        var books: Books = .init(
            rawMaterials: .sample,
            suppliers: .sample
        )

        // confirm
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(Array(books.rawMaterials.values), [.sample])
        XCTAssertEqual(books.rawMaterials.totalBalance(for: \.inventory), 37_555)

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(Array(books.suppliers.values), [.sample])
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 37_555)

        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 37_555)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555)

        // try purchase
        let order: PurchaseOrder = .sample
        XCTAssertNoThrow(
            try books.purchaseRawMaterial(for: order)
        )

        // confirm change
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.totalBalance(for: \.inventory),
                       37_555 + order.amountExVAT)

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables),
                       37_555 + order.amountWithVAT)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance,
                       37_555 + order.amountExVAT)
        XCTAssertEqual(books.ledger[.payables]?.balance,
                       37_555 + order.amountWithVAT)
        XCTAssertEqual(books.ledger[.vatReceivable]?.balance,
                       order.vat)
    }
}
