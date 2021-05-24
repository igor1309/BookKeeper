import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testReceiveCash() throws {
        var books: Books = .init()
        let client0: Client = .init()

        // fail to receive cash from unknown client
        XCTAssertThrowsError(try books.receiveCash(1_000, from: client0.id)) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        // add new client
        let receivables: AccountsReceivable = .init(amount: 1_500)
        let client: Client = .init(receivables: receivables)
        books.add(client: client)

        // confirm balances
        XCTAssertEqual(books.cashBalance, 0)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance(), 1_500)

        // receive cash
        XCTAssertNoThrow(try books.receiveCash(1_000, from: client.id))

        // confirm cash received
        XCTAssertEqual(books.cashBalance, 1_000)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance(), 500)

        // cash receive fail with negative amount
        XCTAssertThrowsError(try books.receiveCash(-1_000, from: client.id)) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.negativeAmount)
        }

        // confirm no changes after fail
        XCTAssertEqual(books.cashBalance, 1_000)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance(), 500)

    }

}
