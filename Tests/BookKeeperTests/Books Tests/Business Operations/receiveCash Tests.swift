import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testReceiveCash() throws {
        var books: Books = .init()

        // confirm
        XCTAssert(books.cashAccount.balanceIsZero)
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.receivables.balanceIsZero)

        // fail to receive cash from unknown client
        XCTAssertThrowsError(
            try books.receiveCash(1_000, from: Client.sample.id)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        // confirm no change after error
        XCTAssert(books.cashAccount.balanceIsZero)
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.receivables.balanceIsZero)

        // add new client
        let client: Client = .init(name: "Client", initialReceivables: 1_500)
        books.add(client: client)

        // confirm balances
        XCTAssert(books.cashAccount.balanceIsZero)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 1_500)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 1_500)
        XCTAssertEqual(books.receivables.balance, 1_500)

        // receive cash
        XCTAssertNoThrow(try books.receiveCash(1_000, from: client.id))

        // confirm cash received
        XCTAssertEqual(books.cashAccount.balance, 1_000)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 500)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 500)
        XCTAssertEqual(books.receivables.balance, 500)

        // cash receive fail with negative amount
        XCTAssertThrowsError(try books.receiveCash(-1_000, from: client.id)) { error in
            XCTAssertEqual(error as? AccountError<Cash>,
                           AccountError.negativeAmount)
        }

        // confirm no changes after fail
        XCTAssertEqual(books.cashAccount.balance, 1_000)
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 500)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 500)
        XCTAssertEqual(books.receivables.balance, 500)
    }

}
