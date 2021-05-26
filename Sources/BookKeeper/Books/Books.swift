import SwiftUI

public struct Books {
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]
    public var clients: [Client.ID: Client]
    public var fixedAssets: [FixedAsset.ID: FixedAsset]

    // balance sheet
    public var cashAccount: Account<Cash>
    public var accumulatedDepreciation: Account<AccumulatedDepreciation>
    public var payables: Account<AccountsPayable>
    public var taxLiabilities: Account<TaxLiabilities>

    // income statement
    public var revenueAccount: RevenueAccount
    public var depreciationExpensesAccount: Account<DepreciationExpenses>

    public init(rawMaterials: [RawMaterial.ID: RawMaterial] = [:],
                wips: [WorkInProgress.ID: WorkInProgress] = [:],
                finishedGoods: [FinishedGood.ID: FinishedGood] = [:],
                clients: [Client.ID: Client] = [:],
                fixedAssets: [FixedAsset.ID: FixedAsset] = [:],
                cashAccount: Account<Cash> = .init(),
                accumulatedDepreciation: Account<AccumulatedDepreciation> = .init(),
                payables: Account<AccountsPayable> = .init(),
                revenueAccount: RevenueAccount = .init(),
                depreciationExpensesAccount: Account<DepreciationExpenses> = .init(),
                taxLiabilities: Account<TaxLiabilities> = .init()
    ) {
        self.rawMaterials = rawMaterials
        self.wips = wips
        self.finishedGoods = finishedGoods
        self.clients = clients
        self.fixedAssets = fixedAssets
        self.cashAccount = cashAccount
        self.accumulatedDepreciation = accumulatedDepreciation
        self.payables = payables
        self.revenueAccount = revenueAccount
        self.depreciationExpensesAccount = depreciationExpensesAccount
        self.taxLiabilities = taxLiabilities
    }

}

public extension Books {
    var isEmpty: Bool {
        rawMaterials.isEmpty
            && wips.isEmpty
            && finishedGoods.isEmpty
            && clients.isEmpty
            && fixedAssets.isEmpty
            && cashBalance == 0
            && accumulatedDepreciationBalance == 0
            && payables.balance() == 0
            && revenueAccountBalance == 0
            && depreciationExpensesAccount.balance() == 0
            && taxLiabilitiesBalance == 0
    }

    var cashBalance: Double { cashAccount.balance() }
    var accumulatedDepreciationBalance: Double { accumulatedDepreciation.balance() }
    var revenueAccountBalance: Double { revenueAccount.balance() }
    var taxLiabilitiesBalance: Double { taxLiabilities.balance() }

}

extension Books: CustomStringConvertible {
    public var description: String {
        let finished = finishedGoods.values.map { "\n\t\($0)" }.joined()
        let clientsStr = clients.values.map { "\n\t\($0)" }.joined()

        return """
        Finished Goods:\(finished)
        Clients:\(clientsStr)
        Revenue: \(revenueAccount.amount)
        Tax Liabilities: \(taxLiabilities.amount)
        """
    }
}

// MARK: - Business Operations
public extension Books {

    enum BooksError: Error {
        case incorrectOrderType
        case unknownClient
        case unknownFinishedGood
        case unknownWorkInProgress
        case costOfProductNotDefined
        case incorrectLifetime
        case nonPositiveAmount
        case depreciationFail
    }

}
