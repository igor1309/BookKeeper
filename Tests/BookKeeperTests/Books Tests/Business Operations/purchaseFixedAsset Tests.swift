import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testPurchaseFixedAsset() throws {
        var books: Books = .init()
        XCTAssert(books.fixedAssets.isEmpty)
        XCTAssertEqual(books.payables.balance(), 0)

        XCTAssertThrowsError(
            try books.purchaseFixedAsset(name: "freezer", lifetimeInYears: 0, amount: 1_000_000)
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.incorrectLifetime)
        }

        XCTAssertThrowsError(
            try books.purchaseFixedAsset(name: "freezer", lifetimeInYears: 7, amount: 0)
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.nonPositiveAmount)
        }

        try books.purchaseFixedAsset(name: "freezer", lifetimeInYears: 7, amount: 1_000_000)
        XCTAssertEqual(books.fixedAssets.values.count, 1)
        XCTAssertEqual(books.fixedAssets.values.first?.name, "freezer")
        XCTAssertEqual(books.payables.balance(), 1_000_000)
    }

}
