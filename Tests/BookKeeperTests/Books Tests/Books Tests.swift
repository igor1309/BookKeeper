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

    func testCashBalance() {
        let books0: Books = .init()
        XCTAssertEqual(books0.cashBalance, 0)

        let cash = CashAccount(amount: 999)
        let books: Books = .init(cashAccount: cash)
        XCTAssertEqual(books.cashBalance, 999)
    }

    func testRevenueAccountBalance() {
        let books0: Books = .init()
        XCTAssertEqual(books0.revenueAccountBalance, 0)

        let revenueAccount = RevenueAccount(amount: 999)
        let books: Books = .init(revenueAccount: revenueAccount)
        XCTAssertEqual(books.revenueAccountBalance, 999)
    }

    func testTaxLiabilitiesBalance() {
        let books0: Books = .init()
        XCTAssertEqual(books0.taxLiabilitiesBalance, 0)

        let taxLiabilities = TaxLiabilities(amount: 999)
        let books: Books = .init(taxLiabilities: taxLiabilities)
        XCTAssertEqual(books.taxLiabilitiesBalance, 999)
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
