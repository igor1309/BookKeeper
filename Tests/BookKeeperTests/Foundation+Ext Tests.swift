import XCTest
@testable import BookKeeper

final class FoundationExtTests: XCTestCase {
    func testTotalBalance() {
        let pairs = (1...10).map { (UUID(), Double($0)) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            let inventory: InventoryAccount = .init(qty: Int(value), amount: value * 10.0)
            return FinishedGood(name: "FinishedGood \(value)",
                                inventory: inventory)
        }
        XCTAssertEqual(finishedGoods.totalBalance(for: \.cogs), 0)
        XCTAssertEqual(finishedGoods.totalBalance(for: \.inventory), 550)
        XCTAssertEqual((1...10).reduce(0) { $0 + $1 * 10},
                       550)
    }

    func testTotalBalanceIsZero() {
        let pairs = (1...10).map { _ in (UUID(), 0.0) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            let inventory: InventoryAccount = .init(qty: Int(value), amount: value * 10.0)
            return FinishedGood(name: "FinishedGood \(value)",
                                inventory: inventory)
        }

        XCTAssert(finishedGoods.totalBalanceIsZero(for: \.cogs))
        XCTAssert(finishedGoods.totalBalanceIsZero(for: \.inventory))
    }

    func testCombineAccounts() {
        let pairs = (1...100).map { (UUID(), Double($0) * 1_000.0) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let balance = pairs.reduce(0) { $0 + $1.1 }

        let clients = dict.mapValues {
            Client(name: "Client \($0)", initialReceivables: $0)
        }
        XCTAssertEqual(
            clients.combined(\.receivables),
            Account<AccountsReceivable>(
                name: "Combined Accounts Receivable",
                amount: balance)
        )

        let suppliers = dict.mapValues {
            Supplier(name: "Supplier \($0)", initialPayables: $0)
        }
        XCTAssertEqual(
            suppliers.combined(\.payables),
            Account<AccountsPayable>(
                name: "Combined Accounts Payable",
                amount: balance)
        )
    }

    let receivables = Account<AccountsReceivable>(amount: 1_000)
    let vatReceivable = Account<VATReceivable>(amount: 100)
    let cash = Account<Cash>(amount: 500)
    let payables = Account<AccountsPayable>(amount: 900)
    let accumulatedDepreciationEquipment = Account<AccumulatedDepreciationEquipment>(amount: 66)
    let taxLiabilities = Account<TaxLiabilities>(amount: 999)

    let cogs = Account<COGS>(amount: 100)
    let depreciationExpenses = Account<DepreciationExpenses>(amount: 100)
    let revenue = Account<Revenue>(amount: 100)

    var simpleAccounts: [SimpleAccount] {
        [receivables.simpleAccount,
         vatReceivable.simpleAccount,
         cash.simpleAccount,
         payables.simpleAccount,
         accumulatedDepreciationEquipment.simpleAccount,
         taxLiabilities.simpleAccount,

         cogs.simpleAccount,
         depreciationExpenses.simpleAccount,
         revenue.simpleAccount,
        ]
    }

    var accounts: [AccountGroup : SimpleAccount] { simpleAccounts.byGroup }

    func testArrayOfAccountProtocolByGroup() {
        XCTAssertEqual(accounts.count, 9)

        XCTAssertEqual(accounts[.balanceSheet(.asset(.currentAsset(.accountsReceivable)))],
                       receivables.simpleAccount)
        XCTAssertEqual(accounts[.balanceSheet(.asset(.currentAsset(.vatReceivable)))],
                       vatReceivable.simpleAccount)
        XCTAssertEqual(accounts[.balanceSheet(.asset(.currentAsset(.cash)))],
                       cash.simpleAccount)
        XCTAssertEqual(accounts[.balanceSheet(.liability(.currentLiability(.accountsPayable)))],
                       payables.simpleAccount)
        XCTAssertEqual(accounts[.balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment)))],
                       accumulatedDepreciationEquipment.simpleAccount)
        XCTAssertEqual(accounts[.balanceSheet(.liability(.currentLiability(.taxesPayable)))],
                       taxLiabilities.simpleAccount)

        XCTAssertEqual(accounts[.incomeStatement(.expense(.cogs))],
                       cogs.simpleAccount)
        XCTAssertEqual(accounts[.incomeStatement(.expense(.depreciation))],
                       depreciationExpenses.simpleAccount)
        XCTAssertEqual(accounts[.incomeStatement(.revenue)],
                       revenue.simpleAccount)
    }

    func testDictionaryProperties() {
        let balanceSheet = accounts.balanceSheet
        XCTAssertEqual(balanceSheet.balance,
                       receivables.balance + vatReceivable.balance + cash.balance - payables.balance - accumulatedDepreciationEquipment.balance - taxLiabilities.balance)

        let assets = accounts.assets
        XCTAssertEqual(assets.balance,
                       receivables.balance + vatReceivable.balance + cash.balance - accumulatedDepreciationEquipment.balance)

        let liabilities = accounts.liabilities
        XCTAssertEqual(liabilities.balance,
                       -payables.balance - taxLiabilities.balance)

        let currentAssets = accounts.currentAssets
        XCTAssertEqual(currentAssets.balance,
                       receivables.balance + vatReceivable.balance + cash.balance)
    }

}

struct SimpleAccount: AccountProtocol {
    var kind: AccountKind
    var group: AccountGroup
    var balance: Double
}

extension Account {
    var simpleAccount: SimpleAccount {
        SimpleAccount(kind: kind, group: group, balance: balance)
    }
}
