import XCTest
import BookKeeper

final class AccountGroupTests: XCTestCase {
    var inventoryAccount: InventoryAccount!

    var accountsReceivable: Account<AccountsReceivable>!
    var vatReceivable: Account<VATReceivable>!
    var cash: Account<Cash>!
    var cogsAccount: Account<COGS>!
    var depreciationExpenses: Account<DepreciationExpenses>!
    var accountsPayable: Account<AccountsPayable>!
    var accumulatedDepreciationEquipment: Account<AccumulatedDepreciationEquipment>!
    var taxLiabilities: Account<TaxLiabilities>!
    var revenueAccount: Account<Revenue>!

    override func setUpWithError() throws {
        inventoryAccount = .init(qty: 1_000, amount: 59_000)

        accountsReceivable = .init(amount: 10_000)
        vatReceivable = .init(amount: 1_200)
        cash = .init(amount: 99_999)
        cogsAccount = .init(amount: 10_000)
        depreciationExpenses = .init(amount: 1_100)
        accountsPayable = .init(amount: 1_100)
        accumulatedDepreciationEquipment = .init(amount: 1_100)
        taxLiabilities = .init(amount: 5_000)
        revenueAccount = .init(amount: 20_000)
    }

}
