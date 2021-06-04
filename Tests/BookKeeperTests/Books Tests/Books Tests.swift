import XCTest
@testable import BookKeeper

final class BooksTests: XCTestCase {
    func testBooksInitNoParameters() {
        let books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        XCTAssert(books.rawMaterials.isEmpty)
        XCTAssert(books.wips.isEmpty)
        XCTAssert(books.finishedGoods.isEmpty)

        XCTAssert(books.clients.isEmpty)
        XCTAssert(books.suppliers.isEmpty)

        XCTAssert(books.equipments.isEmpty)

        XCTAssert(books.ledger.isEmpty)
    }

    func testBooksVariadicInit() {
        let ledger: [Account] = []

        let books1: Books = .init(rawMaterials: .sample,
                                  wips: .sample,
                                  finishedGoods: .sample,
                                  clients: .sample,
                                  suppliers: .sample,
                                  equipments: .sample,
                                  ledger: ledger
        )

        let books2: Books = .init(rawMaterials: [.sample],
                                  wips: [.sample],
                                  finishedGoods: [.sample],
                                  clients: [.sample],
                                  suppliers: [.sample],
                                  equipments: [.sample],
                                  ledger: ledger
        )

        XCTAssertEqual(books1, books2)
    }

    func testBooksInitWithOverwrite() throws {
        // ledger with two active accounts
        let active1: AccountGroup = .cash
        let active2: AccountGroup = .receivables
        let books: Books = .init(ledger: [.init(group: active1),
                                          .init(group: active2)])

        // confirm
        XCTAssertEqual(books.ledger[active1]?.balance, 0)
        XCTAssertNil(books.ledger[active2], "Empty clients should overwrite receivables (active2).")
    }

    #warning("split test into shorter tests")
    // swiftlint:disable function_body_length
    func testBooksInitWithParameters() {
        // initiate books
        let ledger: [Account] = [
            .init(group: .rawInventory, amount: 333),
            .init(group: .wipsInventory, amount: 333),
            .init(group: .finishedInventory, amount: 333),
            .init(group: .equipment, amount: 333),
            .init(group: .receivables, amount: 333),
            .init(group: .payables, amount: 333),
            .init(group: .accumulatedDepreciation, amount: 333),
            .init(group: .cogs, amount: 333),
            .init(group: .depreciationExpenses, amount: 333)
        ]

        let books: Books = .init(rawMaterials: .sample,
                                 wips: .sample,
                                 finishedGoods: .sample,
                                 clients: .sample,
                                 suppliers: .sample,
                                 equipments: .sample,
                                 ledger: ledger
        )

        // confirm
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.first?.value, RawMaterial.sample)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 37_555,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.first?.value, WorkInProgress.sample)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 77_777,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.first?.value, FinishedGood.sample)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.first?.value, Client.sample)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value, Supplier.sample)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.equipments.count, 1)
        XCTAssertEqual(books.equipments.first?.value, Equipment.sample)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.ledger.count, 9)
        XCTAssertEqual(ledger.count, 9)

        XCTAssertNil(books.ledger[.cash], "Account should not be created")
        XCTAssertNil(books.ledger[.revenue], "Account should not be created")
        XCTAssertNil(books.ledger[.vatReceivable], "Account should not be created")
        XCTAssertNil(books.ledger[.taxesPayable], "Account should not be created")
    }
    // swiftlint:enable function_body_length

    func testBooksIsEmpty() throws {
        var books: Books = .init()
        XCTAssert(books.isEmpty)

        try books.addClient(name: "client")
        XCTAssertFalse(books.isEmpty)
    }

    func testBooksBalance() {
        var books: Books = .init()
        XCTAssertEqual(books.balance, 0)

        books = .init(rawMaterials: .sample)
        XCTAssertEqual(books.balance, 37_555)

        books = .init(wips: .sample)
        XCTAssertEqual(books.balance, 77_777)

        books = .init(finishedGoods: .sample)
        XCTAssertEqual(books.balance, 49_000 + 35_000)

        books = .init(clients: .sample)
        XCTAssertEqual(books.balance, 66_666)

        books = .init(suppliers: .sample)
        XCTAssertEqual(books.balance, -37_555)

        books = .init(
            rawMaterials: .sample,
            suppliers: .sample
        )
        XCTAssertEqual(books.balance, 0)
    }

    func testCashBalance() {
        let books0: Books = .init()
        XCTAssertNil(books0.ledger[.cash]?.balanceIsZero)

        let cashAccount: Account = .init(group: .cash, amount: 999)
        let books: Books = .init(ledger: [cashAccount])
        XCTAssertEqual(books.ledger[.cash]?.balance, 999)
    }

    func testRevenueAccountBalance() {
        let books0: Books = .init()
        XCTAssert(books0.ledger.isEmpty)

        let revenueAccount: Account = .init(group: .revenue, amount: 999)
        let books: Books = .init(ledger: [revenueAccount])
        XCTAssertEqual(books.ledger[.revenue]?.balance, 999)
    }

    func testTaxLiabilitiesBalance() {
        let books0: Books = .init()
        XCTAssertNil(books0.ledger[.taxesPayable]?.balanceIsZero)

        let taxLiabilitiesAccount: Account = .init(group: .taxesPayable, amount: 999)
        let books: Books = .init(ledger: [taxLiabilitiesAccount])
        XCTAssertEqual(books.ledger[.taxesPayable]?.balance, 999)
    }

    func testDescription() throws {
        var books: Books = .init()
        XCTAssertEqual(books.description,
                       """
                       Finished Goods:
                       Clients:
                       Revenue: ...
                       Tax Liabilities: ...
                       """)

        try books.addFinishedGood(name: "finishedGood")
        try books.addClient(name: "client")

        XCTAssertEqual([books.description],
                       ["""
                        Finished Goods:
                        \tFinishedGood \'finishedGood\'
                        \tInventory: Inventory(qty: 0, amount: 0.0)
                        \tCOGS: COGS, active: 0.0)
                        Clients:
                        \tClient client(receivables: Accounts Receivable, active: 0.0)
                        Revenue: ...
                        Tax Liabilities: ...
                        """])
        XCTAssertEqual([books.description],
                       ["""
                       Finished Goods:
                       \tFinishedGood \'finishedGood\'
                       \tInventory: Inventory(qty: 0, amount: 0.0)
                       \tCOGS: COGS, active: 0.0)
                       Clients:
                       \tClient client(receivables: Accounts Receivable, active: 0.0)
                       Revenue: ...
                       Tax Liabilities: ...
                       """],
                       "Using array to see escaped special characters")
    }

}
