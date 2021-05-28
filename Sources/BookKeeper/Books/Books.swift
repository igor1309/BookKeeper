import SwiftUI

public struct Books {
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]
    public var clients: [Client.ID: Client]
    public var suppliers: [Supplier.ID: Supplier]
    public var fixedAssets: [FixedAsset.ID: FixedAsset]

    // balance sheet
    public var cashAccount: Account<Cash>
    public var accumulatedDepreciation: Account<AccumulatedDepreciationEquipment>

    public var receivables: Account<AccountsReceivable> {
        clients.combined(\.receivables)
    }
    public var payables: Account<AccountsPayable> {
        suppliers.combined(\.payables)
    }

    public var vatReceivable: Account<VATReceivable>
    public var taxLiabilities: Account<TaxLiabilities>

    // income statement
    public var revenueAccount: Account<Revenue>
    public var depreciationExpensesAccount: Account<DepreciationExpenses>

    public init(rawMaterials: [RawMaterial.ID: RawMaterial] = [:],
                wips: [WorkInProgress.ID: WorkInProgress] = [:],
                finishedGoods: [FinishedGood.ID: FinishedGood] = [:],
                clients: [Client.ID: Client] = [:],
                suppliers: [Supplier.ID: Supplier] = [:],
                fixedAssets: [FixedAsset.ID: FixedAsset] = [:],
                cashAccount: Account<Cash> = .init(),
                accumulatedDepreciation: Account<AccumulatedDepreciationEquipment> = .init(),
                revenueAccount: Account<Revenue> = .init(),
                depreciationExpensesAccount: Account<DepreciationExpenses> = .init(),
                vatReceivable: Account<VATReceivable> = .init(),
                taxLiabilities: Account<TaxLiabilities> = .init()
    ) {
        self.rawMaterials = rawMaterials
        self.wips = wips
        self.finishedGoods = finishedGoods
        self.clients = clients
        self.suppliers = suppliers
        self.fixedAssets = fixedAssets
        self.cashAccount = cashAccount
        self.accumulatedDepreciation = accumulatedDepreciation
        self.revenueAccount = revenueAccount
        self.depreciationExpensesAccount = depreciationExpensesAccount
        self.vatReceivable = vatReceivable
        self.taxLiabilities = taxLiabilities
    }

}

public extension Books {
    var isEmpty: Bool {
        rawMaterials.isEmpty
            && wips.isEmpty
            && finishedGoods.isEmpty
            && clients.isEmpty
            && suppliers.isEmpty
            && fixedAssets.isEmpty
            && cashAccount.balanceIsZero
            && accumulatedDepreciation.balanceIsZero
            && receivables.balanceIsZero
            && payables.balanceIsZero
            && revenueAccount.balanceIsZero
            && depreciationExpensesAccount.balanceIsZero
            && vatReceivable.balanceIsZero
            && taxLiabilities.balanceIsZero
    }

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
        case unknownSupplier
        case unknownFinishedGood
        case unknownWorkInProgress
        case unknownRawMaterial

        case costOfProductNotDefined
        case incorrectLifetime
        case nonPositiveAmount
        case negativeVAT
        case depreciationFail
    }

}
