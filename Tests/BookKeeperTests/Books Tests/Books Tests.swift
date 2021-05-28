import XCTest
// @testable
import BookKeeper

//extension Sequence where Element: AccountProtocol {
//    func totalBalance() -> Double {
//        reduce(0) { $0 + $1.balance }
//    }
//}

final class BooksTests: XCTestCase {
    func testInitNoParameters() {
        let books: Books = .init()
        XCTAssert(books.isEmpty)
        XCTAssert(books.rawMaterialsAll().isEmpty)
        XCTAssert(books.wipsAll().isEmpty)
        XCTAssert(books.finishedGoodsAll().isEmpty)
        XCTAssert(books.clientsAll().isEmpty)
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.fixedAssetsAll().isEmpty)
        XCTAssert(books.cashAccount.balanceIsZero)
        XCTAssert(books.accumulatedDepreciation.balanceIsZero)
        XCTAssert(books.receivables.balanceIsZero)
        XCTAssert(books.payables.balanceIsZero)
        XCTAssert(books.vatReceivable.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.depreciationExpensesAccount.balanceIsZero)
    }

    func testInitWithParameters() {
        // initiate books
        let rawMaterial: RawMaterial = .sample
        let rawMaterials: [RawMaterial.ID: RawMaterial] = [rawMaterial.id: rawMaterial]

        let workInProgress: WorkInProgress = .sample
        let wips: [WorkInProgress.ID: WorkInProgress] = [workInProgress.id: workInProgress]

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedGood: FinishedGood = .init(name: "finished", inventory: inventory)
        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]

        let client: Client = .sample
        let clients: [Client.ID: Client] = [client.id: client]

        let supplier: Supplier = .sample
        let suppliers: [Supplier.ID: Supplier] = [supplier.id: supplier]

        let fixedAsset: FixedAsset = .sample
        let fixedAssets: [FixedAsset.ID: FixedAsset] = [fixedAsset.id: fixedAsset]

        let books: Books = .init(rawMaterials: rawMaterials,
                                 wips: wips,
                                 finishedGoods: finishedGoods,
                                 clients: clients,
                                 suppliers: suppliers,
                                 fixedAssets: fixedAssets,
                                 cashAccount: .init(amount: 666),
                                 accumulatedDepreciation: .init(amount: 333),
                                 revenueAccount: .init(amount: 999),
                                 depreciationExpensesAccount: .init(amount: 222),
                                 vatReceivable: .init(amount: 66),
                                 taxLiabilities: .init(amount: 111)
        )

        // confirm
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.first?.value, rawMaterial)

        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.first?.value, workInProgress)

        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.first?.value, finishedGood)

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.first?.value, client)

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value, supplier)

        XCTAssertEqual(books.fixedAssets.count, 1)
        XCTAssertEqual(books.fixedAssets.first?.value, fixedAsset)

        XCTAssertEqual(books.cashAccount.balance, 666)
        XCTAssertEqual(books.accumulatedDepreciation.balance, 333)
        XCTAssertEqual(books.revenueAccount.balance, 999)
        XCTAssertEqual(books.depreciationExpensesAccount.balance, 222)
        XCTAssertEqual(books.vatReceivable.balance, 66)
        XCTAssertEqual(books.taxLiabilities.balance, 111)
    }

    func testIsEmpty() {
        var books: Books = .init()
        XCTAssert(books.isEmpty)

        let client: Client = .sample
        books.add(client: client)
        XCTAssertFalse(books.isEmpty)
    }

    func testCashBalance() {
        let books0: Books = .init()
        XCTAssert(books0.cashAccount.balanceIsZero)

        let cash: Account<Cash> = .init(amount: 999)
        let books: Books = .init(cashAccount: cash)
        XCTAssertEqual(books.cashAccount.balance, 999)
    }

    func testRevenueAccountBalance() {
        let books0: Books = .init()
        XCTAssert(books0.revenueAccount.balanceIsZero)

        let revenueAccount: Account<Revenue> = .init(amount: 999)
        let books: Books = .init(revenueAccount: revenueAccount)
        XCTAssertEqual(books.revenueAccount.balance, 999)
    }

    func testTaxLiabilitiesBalance() {
        let books0: Books = .init()
        XCTAssert(books0.taxLiabilities.balanceIsZero)

        let taxLiabilities: Account<TaxLiabilities> = .init(amount: 999)
        let books: Books = .init(taxLiabilities: taxLiabilities)
        XCTAssertEqual(books.taxLiabilities.balance, 999)
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

        let finishedGood: FinishedGood = .sample
        books.add(finishedGood: finishedGood)

        let client: Client = .sample
        books.add(client: client)

        XCTAssertEqual([books.description],
                       ["""
                        Finished Goods:
                        \tFinishedGood(inventory: Inventory(amount: 0.0, qty: 0), cogs: COGS(0.0))
                        Clients:
                        \tClient(receivables: AccountsReceivable(0.0))
                        Revenue: 0.0
                        Tax Liabilities: 0.0
                        """])

        XCTAssertEqual([books.description],
                       ["Finished Goods:\n\tFinishedGood(inventory: Inventory(amount: 0.0, qty: 0), cogs: COGS(0.0))\nClients:\n\tClient(receivables: AccountsReceivable(0.0))\nRevenue: 0.0\nTax Liabilities: 0.0"],
                       "Using array to see escaped special characters")

        XCTFail("finish with test: test with some products, clients. etc - after operations")
    }

}
