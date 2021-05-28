import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    // swiftlint:disable function_body_length
    func testBookRevenueWithEmptyBooks() throws {
        // initiate empty books
        var books: Books = .init()
        XCTAssert(books.clientsAll().isEmpty)

        // create sales order and book revenue
        let client: Client = .sample
        let finishedGood: FinishedGood = .sample
        let qty = 100
        let priceExTax = 99.0

        let order: SalesOrder = .init(orderType: .bookRevenue,
                                      clientID: client.id,
                                      finishedGoodID: finishedGood.id,
                                      qty: qty,
                                      priceExTax: priceExTax)
        XCTAssertThrowsError(try books.bookRevenue(for: order)) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        // confirm no change after error
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)

        books.add(client: client)
        XCTAssertThrowsError(try books.bookRevenue(for: order)) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        // confirm no change after error
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)

        books.add(finishedGood: finishedGood)
        XCTAssertThrowsError(try books.bookRevenue(for: order),
                             "Throws error if inventory is empty and cost can't be determined."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.costOfProductNotDefined)
        }

        // confirm no change after error
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)

        XCTAssertThrowsError(try books.bookRevenue(for: order),
                             "Failure due to empty finished goods inventory.") { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.costOfProductNotDefined)
        }

        // confirm no change after error
        XCTAssert(books.clients.totalBalance(for: \.receivables).isZero)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)

        // create production order
        let workInProgress = WorkInProgress()
        let productionOrder: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                                     finishedGoodID: finishedGood.id,
                                                     workInProgressID: workInProgress.id,
                                                     finishedGoodQty: 999)
        // add to books
        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wips.count, 1)
        XCTAssert(books.wips.totalBalance(for: \.inventory).isZero)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssert(books.finishedGoods.totalBalance(for: \.inventory).isZero)

        // add finished goods inventory
        XCTAssertNoThrow(try books.recordFinishedGoods(for: productionOrder))

        // confirm
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory), 49 * -999)

        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49 * 999)

        // book revenue
        XCTAssertNoThrow(try books.bookRevenue(for: order))

        // confirm
        XCTAssert(books.rawMaterials.isEmpty)

        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory), 49.0 * -999)
        let wipInventory = try XCTUnwrap(books.workInProgress(forID: workInProgress.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, -999)
        XCTAssertEqual(wipInventory.balance, 49.0 * -999)

        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49 * (999 - 100))
        let finishedGoodsInventory = try XCTUnwrap(books.finishedGood(forID: finishedGood.id)?.inventory)
        XCTAssertEqual(finishedGoodsInventory.qty, 999 - 100)
        XCTAssertEqual(finishedGoodsInventory.balance, 49 * (999 - 100))

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.totalBalance(for: \.receivables), 99 * 100 * (1 + 0.2))
        let receivables = try XCTUnwrap(books.client(forID: client.id)?.receivables)
        XCTAssertEqual(receivables.balance, order.amountWithTax)
        XCTAssertEqual(receivables.balance, 99 * 100 * (1 + 0.2))

        XCTAssertEqual(books.revenueAccount.balance, order.amountExTax)
        XCTAssertEqual(books.taxLiabilities.balance, order.tax)

        XCTAssertEqual(books.revenueAccount.balance, 100 * 99.0)
        XCTAssertEqual(books.taxLiabilities.balance, 100 * 99.0 * 0.2)
    }
    // swiftlint:enable function_body_length

    func testBookRevenueWithNonEmptyBooks() throws {
        // initiate books (as in testInitWithParameters())
        let finishedGood: FinishedGood = .init(
            name: "Finished",
            inventory: .init(qty: 1_000, amount: 49_000)
        )
        let client: Client = .sample

        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]
        let clients: [Client.ID: Client] = [client.id: client]
        let revenueAccount: Account<Revenue> = .init(amount: 999)
        let taxLiabilities: Account<TaxLiabilities> = .init(amount: 111)

        var books: Books = .init(finishedGoods: finishedGoods,
                                 clients: clients,
                                 revenueAccount: revenueAccount,
                                 taxLiabilities: taxLiabilities
        )

        // confirm
        XCTAssertEqual(books.finishedGoodsAll(), finishedGoods)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id)?.cost(), 49)
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)

        XCTAssertEqual(books.clientsAll(), clients)
        XCTAssertEqual(books.client(forID: client.id), client)

        XCTAssertEqual(books.revenueAccount.balance, 999)
        XCTAssertEqual(books.taxLiabilities.balance, 111)

        // create sales order and book revenue
        let qty = 100
        let priceExVAT = 99.0

        let order = SalesOrder(orderType: .bookRevenue,
                               clientID: client.id,
                               finishedGoodID: finishedGood.id,
                               qty: qty,
                               priceExTax: priceExVAT)
        XCTAssertNoThrow(try books.bookRevenue(for: order))

        let booksFinishedGood = try XCTUnwrap(books.finishedGood(forID: finishedGood.id))
        XCTAssertEqual(booksFinishedGood.id, finishedGood.id)
        XCTAssertEqual(booksFinishedGood.inventory.cost(), 49)
        XCTAssertEqual(booksFinishedGood.inventory.qty, 1_000 - 100)
        XCTAssertEqual(booksFinishedGood.inventory.amount, 49_000 - (49 * 100))
        XCTAssertEqual(booksFinishedGood.inventory.amount, 44_100)
        XCTAssertEqual(booksFinishedGood.inventory.balance, 44_100)
        XCTAssertEqual(booksFinishedGood.cogs.balance, 49 * 100)

        XCTAssertEqual(books.client(forID: client.id)?.id, client.id)

        XCTAssertEqual(books.revenueAccount.balance, 999 + 100 * 99.0)
        XCTAssertEqual(books.taxLiabilities.balance, 111 + 100 * 99.0 * 0.2)
    }

}
