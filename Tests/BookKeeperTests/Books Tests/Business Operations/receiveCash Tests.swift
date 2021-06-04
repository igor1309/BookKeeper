import XCTest
import BookKeeper

// MARK: Business Operations

extension BooksTests {
    func testReceiveCashUnknownClientError() throws {
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // fail to receive cash from unknown client
        XCTAssertThrowsError(
            try books.receiveCash(1_000, from: Client.sample.id)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        // confirm no change after error
        XCTAssert(books.isEmpty)
    }

    func testReceiveCashInsufficientBalanceErrors() {
        let client: Client = .sample
        var books: Books = .init(clients: client)

        // confirm balances
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 66_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)
        XCTAssertNil(books.ledger[.cash], "Should be no such account in the ledger")
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // receive huge cash
        XCTAssertThrowsError(
            try books.receiveCash(1_000_000, from: client.id)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(.receivables))
        }

        // confirm no change after error
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 66_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)
        XCTAssertNil(books.ledger[.cash], "Should be no such account in the ledger")
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)
    }

    func testReceiveCashNegativeAmountErrors() {
        let client: Client = .sample
        var books: Books = .init(clients: client)

        // confirm balances
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 66_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertNil(books.ledger[.cash], "Should be no such account in the ledger")
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // cash receive fail with negative amount
        XCTAssertThrowsError(try books.receiveCash(-1_000, from: client.id)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        // confirm no changes after fail
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 66_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertNil(books.ledger[.cash], "Should be no such account in the ledger")
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

    }

    func testReceiveCashNoErrors() {
        let client: Client = .sample
        var books: Books = .init(clients: client)

        // confirm balances
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 66_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertNil(books.ledger[.cash], "Should be no such account in the ledger")
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // receive cash
        XCTAssertNoThrow(try books.receiveCash(10_000, from: client.id))

        // confirm cash received
        XCTAssertEqual(books.clients[client.id]?.receivables.balance, 56_666)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 56_666)
        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.cash]?.balance, 10_000)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 56_666)
    }
}
