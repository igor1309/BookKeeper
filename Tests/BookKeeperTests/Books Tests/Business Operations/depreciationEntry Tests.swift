import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testDepreciateFixedAssets() throws {
        // open books and purchase equipment
        var books: Books = .init()
        try books.purchaseFixedAsset(name: "Freezer", lifetimeInYears: 5, amount: 6_000_000)
        XCTAssertEqual(books.depreciationExpensesAccount.balance(), 0)

        try books.depreciateFixedAssets()
        XCTAssertEqual(books.depreciationExpensesAccount.balance(), 6_000_000 / 5 / 12)
        XCTAssertEqual(books.depreciationExpensesAccount.balance(), 100_000)

        for _ in 1...59 {
            try books.depreciateFixedAssets()
        }
        XCTAssertEqual(books.depreciationExpensesAccount.balance(), 6_000_000)

        XCTAssertThrowsError(
            try books.depreciateFixedAssets()
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.depreciationFail)
        }
    }

}
