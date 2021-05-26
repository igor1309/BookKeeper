import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
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
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownClient)
        }

        books.add(client: client)
        XCTAssertThrowsError(try books.bookRevenue(for: order)) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        books.add(finishedGood: finishedGood)
        XCTAssertThrowsError(try books.bookRevenue(for: order),
                             "Throws error if inventory is empty and cost can't be determined."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.costOfProductNotDefined)
        }

        XCTAssertThrowsError(try books.bookRevenue(for: order),
                             "Failure due to empty finished goods inventory.") { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.costOfProductNotDefined)
        }

        // create production order
        let workInProgress = WorkInProgress()
        let productionOrder: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                                     finishedGoodID: finishedGood.id,
                                                     workInProgressID: workInProgress.id,
                                                     finishedGoodQty: 999)
        // add to books
        books.add(finishedGood: finishedGood)
        books.add(workInProgress: workInProgress)

        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)

        XCTAssertEqual(books.wipsAll().first?.value.inventory.balance(), 0)
        XCTAssertEqual(books.finishedGoodsAll().first?.value.inventory.balance(), 0)

        // add finished goods inventory
        XCTAssertNoThrow(try books.recordFinishedGoods(for: productionOrder))

        // confirm
        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)

        XCTAssertEqual(books.wipsAll().first?.value.inventory.balance(), 49 * -999)
        XCTAssertEqual(books.finishedGoodsAll().first?.value.inventory.balance(), 49 * 999)

        // book revenue
        XCTAssertNoThrow(try books.bookRevenue(for: order))

        // confirm
        XCTAssert(books.rawMaterialsAll().isEmpty)

        XCTAssertEqual(books.wipsAll().count, 1)
        let wipInventory = try XCTUnwrap(books.workInProgress(forID: workInProgress.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, -999)
        XCTAssertEqual(wipInventory.balance(), 49.0 * -999)

        XCTAssertEqual(books.finishedGoodsAll().count, 1)
        let finishedGoodsInventory = try XCTUnwrap(books.finishedGood(forID: finishedGood.id)?.inventory)
        XCTAssertEqual(finishedGoodsInventory.qty, 999 - 100)
        XCTAssertEqual(finishedGoodsInventory.balance(), 49 * (999 - 100))

        XCTAssertEqual(books.clientsAll().count, 1)
        let receivables = try XCTUnwrap(books.client(forID: client.id)?.receivables)
        XCTAssertEqual(receivables.balance(), order.amountWithTax)
        XCTAssertEqual(receivables.balance(), 99 * 100 * (1 + 0.2))

        XCTAssertEqual(books.revenueAccountBalance, order.amountExTax)
        XCTAssertEqual(books.taxLiabilitiesBalance, order.tax)

        XCTAssertEqual(books.revenueAccountBalance, 100 * 99.0)
        XCTAssertEqual(books.taxLiabilitiesBalance, 100 * 99.0 * 0.2)
    }

    func testBookRevenueWithNonEmptyBooks() throws {
        // initiate books (as in testInitWithParameters())
        let finishedGood: FinishedGood = .init(
            name: "Finished",
            inventory: .init(qty: 1_000, amount: 49_000)
        )
        let client: Client = .sample

        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]
        let clients: [Client.ID: Client] = [client.id: client]
        let revenueAccount: RevenueAccount = .init(amount: 999)
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
        XCTAssertEqual(books.finishedGoodsAll().values.map(\.inventory).totalBalance(), 49_000)

        XCTAssertEqual(books.clientsAll(), clients)
        XCTAssertEqual(books.client(forID: client.id), client)

        XCTAssertEqual(books.revenueAccountBalance, 999)
        XCTAssertEqual(books.taxLiabilitiesBalance, 111)

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
        XCTAssertEqual(booksFinishedGood.inventory.balance(), 44_100)
        XCTAssertEqual(booksFinishedGood.cogs.balance(), 49 * 100)

        XCTAssertEqual(books.client(forID: client.id)?.id, client.id)

        XCTAssertEqual(books.revenueAccountBalance, 999 + 100 * 99.0)
        XCTAssertEqual(books.taxLiabilitiesBalance, 111 + 100 * 99.0 * 0.2)
    }


}
