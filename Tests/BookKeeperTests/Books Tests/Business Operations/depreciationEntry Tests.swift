import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testDepreciateFixedAssets() throws {
        // open books and purchase equipment
        var books: Books = .init()

        // confirm
        XCTAssert(books.depreciationExpensesAccount.balanceIsZero)
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssert(books.fixedAssets.sum(for: \.depreciation).isZero)

        // purchase equipment
        let supplier: Supplier = .init(name: "Supplier")
        books.add(supplier: supplier)

        XCTAssertNoThrow(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "Freezer",
                                         lifetimeInYears: 5,
                                         amountExVAT: 6_000_000)
        )

        // confirm
        XCTAssert(books.depreciationExpensesAccount.balanceIsZero)
        XCTAssertFalse(books.fixedAssets.isEmpty)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 6_000_000)
        XCTAssert(books.fixedAssets.sum(for: \.depreciation).isZero)

        // try
        XCTAssertNoThrow(try books.depreciateFixedAssets())

        // confirm
        XCTAssertFalse(books.depreciationExpensesAccount.balanceIsZero)
        XCTAssertEqual(books.depreciationExpensesAccount.balance, 6_000_000 / 5 / 12)
        XCTAssertEqual(books.depreciationExpensesAccount.balance, 100_000)

        XCTAssertFalse(books.fixedAssets.isEmpty)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 6_000_000)
        XCTAssertFalse(books.fixedAssets.sum(for: \.depreciation).isZero)
        XCTAssertEqual(books.fixedAssets.sum(for: \.depreciation), 100_000)

        // more depreciation
        for _ in 1...59 {
            try books.depreciateFixedAssets()
        }

        // confirm
        XCTAssertEqual(books.depreciationExpensesAccount.balance, 6_000_000)
        XCTAssertEqual(books.fixedAssets.sum(for: \.depreciation), 6_000_000)

        XCTAssertThrowsError(
            try books.depreciateFixedAssets()
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.depreciationFail)
        }

        // confirm no change after error
        XCTAssertEqual(books.depreciationExpensesAccount.balance, 6_000_000)
        XCTAssertEqual(books.fixedAssets.sum(for: \.depreciation), 6_000_000)
    }

}
