import XCTest
// @testable
import BookKeeper

final class BooksPayInvoiceTests: XCTestCase {
    func testPayInvoice() throws {
        var books: Books = .init(cashAccount: .init(amount: 700_000))
        XCTAssertEqual(books.cashBalance, 700_000)
        XCTAssertEqual(books.payables.balance(), 0)

        try books.purchaseFixedAsset(name: "freezer", lifetimeInYears: 7, amount: 1_000_000)
        XCTAssertEqual(books.payables.balance(), 1_000_000)

        XCTAssertThrowsError(try books.payInvoice(amount: 800_000)) { error in
          XCTAssertEqual(error as! AccountError,
                         AccountError.insufficientBalance(books.cashAccount))
        }

        try books.payInvoice(amount: 600_000)
        XCTAssertEqual(books.cashBalance, 100_000)
        XCTAssertEqual(books.payables.balance(), 400_000)
    }

    func testPayInvoice2() throws {
        var books: Books = .init(cashAccount: .init(amount: 2_000_000))
        XCTAssertEqual(books.cashBalance, 2_000_000)
        XCTAssertEqual(books.payables.balance(), 0)

        try books.purchaseFixedAsset(name: "freezer", lifetimeInYears: 7, amount: 1_000_000)
        XCTAssertEqual(books.payables.balance(), 1_000_000)

        XCTAssertThrowsError(try books.payInvoice(amount: 2_000_000)) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(books.payables))
        }

        try books.payInvoice(amount: 1_000_000)
        XCTAssertEqual(books.cashBalance, 1_000_000)
        XCTAssertEqual(books.payables.balance(), 0)
    }

}
