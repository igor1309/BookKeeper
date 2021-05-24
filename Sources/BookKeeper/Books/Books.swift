import SwiftUI

public struct Books {
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]
    public var clients: [Client.ID: Client]
    public var fixedAssets: [FixedAsset.ID: FixedAsset]

    // balance sheet
    public var cashAccount: CashAccount
    public var accumulatedDepreciation: AccumulatedDepreciation
    public var payables: AccountsPayable
    public var taxLiabilities: TaxLiabilities

    // income statement
    public var revenueAccount: RevenueAccount
    public var depreciationExpenses: DepreciationExpenses

    public init(rawMaterials: [RawMaterial.ID: RawMaterial]? = nil,
                wips: [WorkInProgress.ID: WorkInProgress]? = nil,
                finishedGoods: [FinishedGood.ID: FinishedGood]? = nil,
                clients: [Client.ID: Client]? = nil,
                fixedAssets: [FixedAsset.ID: FixedAsset]? = nil,
                cashAccount: CashAccount? = nil,
                accumulatedDepreciation: AccumulatedDepreciation? = nil,
                payables: AccountsPayable? = nil,
                revenueAccount: RevenueAccount? = nil,
                depreciationExpenses: DepreciationExpenses? = nil,
                taxLiabilities: TaxLiabilities? = nil
    ) {
        self.rawMaterials = rawMaterials ?? [:]
        self.wips = wips ?? [:]
        self.finishedGoods = finishedGoods ?? [:]
        self.clients = clients ?? [:]
        self.fixedAssets = fixedAssets ?? [:]
        self.cashAccount = cashAccount ?? .init()
        self.accumulatedDepreciation = accumulatedDepreciation ?? .init()
        self.payables = payables ?? .init()
        self.revenueAccount = revenueAccount ?? .init()
        self.depreciationExpenses = depreciationExpenses ?? .init()
        self.taxLiabilities = taxLiabilities ?? .init()
    }

}

public extension Books {
    var isEmpty: Bool {
        rawMaterials.isEmpty
            && wips.isEmpty
            && finishedGoods.isEmpty
            && clients.isEmpty
            && cashBalance == 0
            && revenueAccountBalance == 0
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
