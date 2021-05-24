import XCTest
// @testable
import BookKeeper

final class BooksDepreciationEntryTests: XCTestCase {
    func testDepreciationEntry() throws {
        // open books and purchase equipment
        var books: Books = .init()
        try books.purchaseFixedAsset(name: "Freezer", lifetimeInYears: 5, amount: 6_000_000)
        XCTAssertEqual(books.depreciationExpenses.balance(), 0)

        try books.depreciationEntry()
        XCTAssertEqual(books.depreciationExpenses.balance(), 6_000_000 / 5 / 12)
        XCTAssertEqual(books.depreciationExpenses.balance(), 100_000)

        for _ in 1...59 {
            try books.depreciationEntry()
        }
        XCTAssertEqual(books.depreciationExpenses.balance(), 6_000_000)

        XCTAssertThrowsError(
            try books.depreciationEntry()
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.depreciationFail)
        }
    }

}
