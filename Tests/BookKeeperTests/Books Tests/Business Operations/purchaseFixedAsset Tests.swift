import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    // swiftlint:disable function_body_length
    func testPurchaseFixedAsset() throws {
        var books: Books = .init()
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)

        // create supplier and try to purchase asset
        let supplier: Supplier = .init(name: "Supplier")
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)

        // add supplier and try to purchase asset with wrong lifetime
        books.add(supplier: supplier)
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 0,
                                         amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.incorrectLifetime)
        }

        // confirm no change after error
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)

        // try to purchase asset with wrong amount
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 0)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.nonPositiveAmount)
        }

        // confirm no change after error
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)

        // try to purchase asset with negative VAT rate
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 0,
                                         vatRate: -10/100)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.nonPositiveAmount)
        }

        // confirm no change after error
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)

        // try to purchase
        try books.purchaseFixedAsset(supplierID: supplier.id,
                                     assetName: "freezer",
                                     lifetimeInYears: 13,
                                     amountExVAT: 1_000_000
        )

        // confirm
        XCTAssertEqual(books.fixedAssets.values.count, 1)
        XCTAssertEqual(books.fixedAssets.values.first?.name, "freezer")
        XCTAssertEqual(books.fixedAssets.values.first?.lifetime, 13)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000)

        XCTAssertEqual(books.vatReceivable.balance, 200_000)

        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables),
                       1_200_000,
                       "Should include VAT")
        XCTAssertEqual(books.payables.balance, 1_200_000,
                       "Should include VAT")
    }
    // swiftlint:enable function_body_length

}
