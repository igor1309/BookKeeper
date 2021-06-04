import XCTest
import BookKeeper

final class AccountGroupTests: XCTestCase {
    var inventoryAccount: InventoryAccount!

    var accountsReceivable: Account!
    var vatReceivable: Account!
    var cash: Account!
    var cogsAccount: Account!
    var depreciationExpenses: Account!
    var accountsPayable: Account!
    var accumulatedDepreciationEquipment: Account!
    var taxLiabilities: Account!
    var revenueAccount: Account!

    override func setUpWithError() throws {
        inventoryAccount = .init(type: .finishedGoods, qty: 1_000, amount: 59_000)

        accountsReceivable = .init(group: .receivables, amount: 10_000)
        vatReceivable = .init(group: .vatReceivable, amount: 1_200)
        cash = .init(group: .cash, amount: 99_999)
        cogsAccount = .init(group: .cogs, amount: 10_000)
        depreciationExpenses = .init(group: .depreciationExpenses, amount: 1_100)
        accountsPayable = .init(group: .payables, amount: 1_100)
        accumulatedDepreciationEquipment = .init(group: .accumulatedDepreciation, amount: 1_100)
        taxLiabilities = .init(group: .taxesPayable, amount: 5_000)
        revenueAccount = .init(group: .revenue, amount: 20_000)
    }

}
