import XCTest
// @testable
import BookKeeper

extension Sequence where Element: AccountProtocol {
    func totalBalance() -> Double {
        reduce(0) { $0 + $1.balance() }
    }
}

final class BooksTests: XCTestCase {
    func testInitNoParameters() {
        let books: Books = .init()
        XCTAssert(books.rawMaterialsAll().isEmpty)
        XCTAssert(books.wipsAll().isEmpty)
        XCTAssert(books.finishedGoodsAll().isEmpty)
        XCTAssert(books.clientsAll().isEmpty)
        XCTAssertEqual(books.cashBalance, 0)
        XCTAssertEqual(books.revenueAccountBalance, 0)
        XCTAssertEqual(books.taxLiabilitiesBalance, 0)
    }

    func testInitWithParameters() {
        // initiate books
        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedGood: FinishedGood = .init(inventory: inventory, cogs: COGS())

        let client: Client = .init()

        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]
        let clients: [Client.ID: Client] = [client.id: client]
        let revenueAccount: RevenueAccount = .init(amount: 999)
        let taxLiabilities: TaxLiabilities = .init(amount: 111)

        let books: Books = .init(finishedGoods: finishedGoods,
                                 clients: clients,
                                 revenueAccount: revenueAccount,
                                 taxLiabilities: taxLiabilities
        )

        // confirm
        XCTAssert(books.rawMaterialsAll().isEmpty)
        XCTAssert(books.wipsAll().isEmpty)

        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id)?.cost(), 49)
        XCTAssertEqual(books.finishedGoodsAll().values.map(\.inventory).totalBalance(), 49_000)

        XCTAssertEqual(books.client(forID: client.id), client)

        XCTAssertEqual(books.revenueAccountBalance, 999)
        XCTAssertEqual(books.taxLiabilitiesBalance, 111)
    }

    func testIsEmpty() {
        var books: Books = .init()
        XCTAssert(books.isEmpty)

        let client: Client = .init()
        books.add(client: client)
        XCTAssertFalse(books.isEmpty)
    }

    func testRawMaterialForID() {
        var books: Books = .init()
        let rawMaterial: RawMaterial = .init()
        XCTAssertNil(books.rawMaterial(forID: rawMaterial.id))

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)
    }

    func testWorkInProgressForID() {
        var books: Books = .init()
        let workInProgress: WorkInProgress = .init()
        XCTAssertNil(books.workInProgress(forID: workInProgress.id))

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)
    }

    func testFinishedGoodForID() {
        var books: Books = .init()
        let finishedGood: FinishedGood = .init()
        XCTAssertNil(books.finishedGood(forID: finishedGood.id))

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
    }

    func testClientForID() {
        var books: Books = .init()
        let client: Client = .init()
        XCTAssertNil(books.client(forID: client.id))

        books.add(client: client)
        XCTAssertEqual(books.client(forID: client.id), client)
    }

    func testDescription() throws {
        var books: Books = .init()
        XCTAssertEqual(books.description,
                       """
                       Finished Goods:
                       Clients:
                       Revenue: 0.0
                       Tax Liabilities: 0.0
                       """)

        let finishedGood: FinishedGood = .init()
        books.add(finishedGood: finishedGood)

        let client: Client = .init()
        books.add(client: client)

        XCTAssertEqual([books.description],
                       ["""
                        Finished Goods:
                        \tFinishedGood(inventory: Inventory(amount: 0.0, qty: 0), cogs: COGS(0.0))
                        Clients:
                        \tClient(receivables: AccountReceivable(0.0))
                        Revenue: 0.0
                        Tax Liabilities: 0.0
                        """])

        XCTAssertEqual([books.description],
                       ["Finished Goods:\n\tFinishedGood(inventory: Inventory(amount: 0.0, qty: 0), cogs: COGS(0.0))\nClients:\n\tClient(receivables: AccountReceivable(0.0))\nRevenue: 0.0\nTax Liabilities: 0.0"],
                       "Using array to see escaped special characters")

        XCTFail("finish with test: test with some products, clients. etc - after operations")
    }
}

// MARK: - Business Operations
extension BooksTests {
    func testBookRevenueWithEmptyBooks() throws {
        // initiate empty books
        var books: Books = .init()
        XCTAssert(books.clientsAll().isEmpty)

        // create sales order and book revenue
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()
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
        let finishedGood: FinishedGood = .init(inventory: .init(qty: 1_000, amount: 49_000),
                                               cogs: .init())

        let client: Client = .init()

        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]
        let clients: [Client.ID: Client] = [client.id: client]
        let revenueAccount: RevenueAccount = .init(amount: 999)
        let taxLiabilities: TaxLiabilities = .init(amount: 111)

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

    func testRecordFinishedGoods() throws {
        // initiate empty books
        var books: Books = .init()

        // initiate product with empty inventories
        let finishedGood: FinishedGood = .init()
        let workInProgress = WorkInProgress()

        // create production order with someOtherType
        let orderWithOtherType: ProductionOrder = .init(orderType: .someOtherType,
                                                        finishedGoodID: finishedGood.id,
                                                        workInProgressID: workInProgress.id,
                                                        finishedGoodQty: 999)

        XCTAssertThrowsError(try books.recordFinishedGoods(for: orderWithOtherType),
                             "Should fail: incorrect order type."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.incorrectOrderType)
        }

        // create production order
        let order: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           workInProgressID: workInProgress.id,
                                           finishedGoodQty: 999)

        XCTAssertThrowsError(try books.recordFinishedGoods(for: order),
                             "Should fail since finishedGood is not in books."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }
        // add to books
        books.add(finishedGood: finishedGood)
        XCTAssertThrowsError(try books.recordFinishedGoods(for: order),
                             "Should fail since workInProgress is not in books."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownWorkInProgress)
        }

        books.add(workInProgress: workInProgress)
        XCTAssertNoThrow(try books.recordFinishedGoods(for: order))

        // confirm
        XCTAssert(books.rawMaterialsAll().isEmpty)
        XCTAssertFalse(books.wipsAll().isEmpty)
        XCTAssertFalse(books.finishedGoodsAll().isEmpty)
        XCTAssert(books.clientsAll().isEmpty)
        XCTAssertEqual(books.revenueAccountBalance, 0)
        XCTAssertEqual(books.taxLiabilitiesBalance, 0)

        let wipInventory = try XCTUnwrap(books.workInProgress(forID: workInProgress.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, -999)
        XCTAssertEqual(wipInventory.amount, 49 * -999)
        XCTAssertEqual(wipInventory.balance(), 49 * -999)

        let finishedGoodInventory = try XCTUnwrap(books.finishedGood(forID: finishedGood.id)?.inventory)
        XCTAssertEqual(finishedGoodInventory.qty, 999)
        XCTAssertEqual(finishedGoodInventory.amount, 49 * 999)
        XCTAssertEqual(finishedGoodInventory.balance(), 49 * 999)
    }
}

// MARK: - Add
extension BooksTests {
    func testAddClient() {
        let client: Client = .init()
        var books: Books = .init()
        XCTAssert(books.clientsAll().isEmpty)

        books.add(client: client)
        XCTAssertEqual(books.clientsAll().count, 1)
        XCTAssertEqual(books.client(forID: client.id), client)

        books.add(client: client)
        XCTAssertEqual(books.clientsAll().count, 1)
        XCTAssertEqual(books.client(forID: client.id), client,
                       "Adding element with the same id should not duplicate.")

        let client2: Client = .init()
        books.add(client: client2)
        XCTAssertEqual(books.clientsAll().count, 2)
        XCTAssertEqual(books.client(forID: client2.id), client2)
    }

    func testAddFinishedGood() {
        let finishedGood: FinishedGood = .init()
        var books: Books = .init()
        XCTAssert(books.finishedGoodsAll().isEmpty)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood,
                       "Adding element with the same id should not duplicate.")

        let finishedGood2: FinishedGood = .init()
        books.add(finishedGood: finishedGood2)
        XCTAssertEqual(books.finishedGoodsAll().count, 2)
        XCTAssertEqual(books.finishedGood(forID: finishedGood2.id), finishedGood2)
    }

    func testAddWorkInProgress() {
        let workInProgress: WorkInProgress = .init()
        var books: Books = .init()
        XCTAssert(books.wipsAll().isEmpty)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress,
                       "Adding element with the same id should not duplicate.")

        let workInProgress2: WorkInProgress = .init()
        books.add(workInProgress: workInProgress2)
        XCTAssertEqual(books.wipsAll().count, 2)
        XCTAssertEqual(books.workInProgress(forID: workInProgress2.id), workInProgress2)
    }

    func testAddRawMaterial() {
        let rawMaterial: RawMaterial = .init()
        var books: Books = .init()
        XCTAssert(books.rawMaterialsAll().isEmpty)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterialsAll().count, 1)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterialsAll().count, 1)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial,
                       "Adding element with the same id should not duplicate.")

        let rawMaterial2: RawMaterial = .init()
        books.add(rawMaterial: rawMaterial2)
        XCTAssertEqual(books.rawMaterialsAll().count, 2)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial2.id), rawMaterial2)
    }

}

// MARK: - TBD
extension BooksTests {
    func testInventoryPurchases() {
        // initiate empty books
        let books: Books = .init()
        //let inventoryPurchases = books.inventoryPurchases()
        //XCTAssertEqual(inventoryPurchases, 0)

        XCTFail("finish with test")
    }

}
