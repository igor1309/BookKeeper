import XCTest
@testable import BookKeeper

// MARK: Business Operations

extension BooksTests {
    func testBookRevenueUnknownClientError() {
        // initiate empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // try book revenue
        let order: SalesOrder = .bookRevenue
        XCTAssertThrowsError(
            try books.bookRevenue(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        // confirm no change after error
        XCTAssert(books.isEmpty)
    }

    func testBookRevenueUnknownFinishedGoodError() {
        // new books
        var books: Books = .init(clients: .sample)

        // confirm
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.client(forID: Client.sample.id), Client.sample)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // try book revenue
        let order: SalesOrder = .bookRevenue
        XCTAssertThrowsError(
            try books.bookRevenue(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        // confirm no change after error
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.client(forID: Client.sample.id), Client.sample)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)
    }

    func testBookRevenueCostOfProductNotDefinedError() {
        // new books
        var books: Books = .init(
            finishedGoods: .init(name: "Finished"),
            clients: .sample
        )

        // confirm
        XCTAssertEqual(books.finishedGoods.count, 1)

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.client(forID: Client.sample.id), Client.sample)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 0)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 0)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // try book revenue
        let order: SalesOrder = .bookRevenue
        XCTAssertThrowsError(
            try books.bookRevenue(for: order)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        // confirm no change after error
        XCTAssertEqual(books.finishedGoods.count, 1)

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.client(forID: Client.sample.id), Client.sample)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 0)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 0)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)
    }

    func testBookRevenueNoError() {
        // new books
        var books: Books = .init(
            finishedGoods: .sample,
            clients: .sample
        )

        // confirm
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods[FinishedGood.sample.id]?.cost(), 49)

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666)

        // try book revenue
        let order: SalesOrder = .bookRevenue
        XCTAssertNoThrow(try books.bookRevenue(for: order))

        // confirm
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods[FinishedGood.sample.id]?.cost(), 49, "Cost should not change")

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 66_666 + 100 * 99 * 1.2)

        XCTAssertEqual(books.ledger.count, 5)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000 - 100 * 49)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000 + 100 * 49)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666 + 100 * 99 * 1.2)
    }

}
