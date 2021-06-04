import XCTest
//@testable
import BookKeeper

final class FoundationExtTests: XCTestCase {
    func testDictionaryContainsAtKeyPath() {
        let names = ["aaa", "bbb", "ccc"]
        let clientsArray: [Client] = names.map { Client(name: $0) }
        let clients: [Client.ID: Client] = clientsArray.keyedBy(keyPath: \.id)

        XCTAssert(clients.contains("aaa", at: \.name))
        XCTAssertFalse(clients.contains("abc", at: \.name))
    }

    func testDictionarySumByKeyPath() {
        let accountsArray = [
            Account(group: .cash, amount: 100),
            Account(group: .cogs, amount: 200),
            Account(group: .accumulatedDepreciation, amount: 300),
            Account(group: .depreciationExpenses, amount: 400)
        ]
        let accounts: [AccountGroup: Account] = accountsArray.keyedBy(keyPath: \.group)

        let sum = accounts.sum(for: \.balance)
        XCTAssertEqual(sum, 100 + 200 + 300 + 400)
    }

    func testTotalBalance() {
        let pairs = (1...10).map { (UUID(), Double($0)) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            FinishedGood(name: "FinishedGood \(value)",
                         initialInventoryQty: Int(value),
                         initialInventoryValue: value * 10.0,
                         initialCOGS: value * 5)
        }

        XCTAssertEqual((1...10).reduce(0) { $0 + $1 }, 55)
        XCTAssertEqual(finishedGoods.totalBalance(for: \.inventory), 55 * 10)
        XCTAssertEqual(finishedGoods.totalBalance(for: \.cogs), 55 * 5)
    }

    func testTotalBalanceIsZero() {
        let pairs = (1...10).map { _ in (UUID(), 0.0) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            FinishedGood(name: "FinishedGood \(value)",
                         initialInventoryQty: Int(value),
                         initialInventoryValue: value * 10.0,
                         initialCOGS: value * 5)
        }

        XCTAssertEqual(finishedGoods.totalBalance(for: \.cogs), 0)
        XCTAssertEqual(finishedGoods.totalBalance(for: \.inventory), 0)
    }

    //    func testCombineAccounts() {
    //        let pairs = (1...100).map { (UUID(), Double($0) * 1_000.0) }
    //        let dict = Dictionary(uniqueKeysWithValues: pairs)
    //
    //        let balance = pairs.reduce(0) { $0 + $1.1 }
    //
    //        let clients = dict.mapValues {
    //            Client(name: "Client \($0)", initialReceivables: $0)
//        }
//        XCTAssertEqual(
//            clients.combined(\.receivables),
//            Account<AccountsReceivable>(
//                name: "Combined Accounts Receivable",
//                amount: balance)
//        )
//
//        let suppliers = dict.mapValues {
//            Supplier(name: "Supplier \($0)", initialPayables: $0)
//        }
//        XCTAssertEqual(
//            suppliers.combined(\.payables),
//            Account<AccountsPayable>(
//                name: "Combined Accounts Payable",
//                amount: balance)
//        )
//    }

    let receivables = Account(group: .receivables, amount: 1_000)
    let vatReceivable = Account(group: .vatReceivable, amount: 100)
    let cash = Account(group: .cash, amount: 500)
    let payables = Account(group: .payables, amount: 900)
    let accumulatedDepreciationEquipment = Account(group: .accumulatedDepreciation, amount: 66)
    let taxLiabilities = Account(group: .taxesPayable, amount: 999)

    let cogs = Account(group: .cogs, amount: 100)
    let depreciationExpenses = Account(group: .depreciationExpenses, amount: 100)
    let revenue = Account(group: .revenue, amount: 100)

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

    // var accounts: [AccountGroup: SimpleAccount] { simpleAccounts.byGroup }
    var accounts: [AccountGroup: SimpleAccount] { simpleAccounts.keyedBy(keyPath: \.group) }

    func testArrayOfAccountProtocolByGroup() {
        XCTAssertEqual(accounts.count, 9)

        XCTAssertEqual(accounts[.receivables],
                       receivables.simpleAccount)
        XCTAssertEqual(accounts[.vatReceivable],
                       vatReceivable.simpleAccount)
        XCTAssertEqual(accounts[.cash],
                       cash.simpleAccount)
        XCTAssertEqual(accounts[.payables],
                       payables.simpleAccount)
        XCTAssertEqual(accounts[.accumulatedDepreciation],
                       accumulatedDepreciationEquipment.simpleAccount)
        XCTAssertEqual(accounts[.taxesPayable],
                       taxLiabilities.simpleAccount)

        XCTAssertEqual(accounts[.cogs],
                       cogs.simpleAccount)
        XCTAssertEqual(accounts[.depreciationExpenses],
                       depreciationExpenses.simpleAccount)
        XCTAssertEqual(accounts[.revenue],
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
