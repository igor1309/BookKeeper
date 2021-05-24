import SwiftUI

public struct Books {
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]
    public var clients: [Client.ID: Client]

    public var cashAccount: CashAccount
    public var revenueAccount: RevenueAccount
    public var taxLiabilities: TaxLiabilities

    public init(rawMaterials: [RawMaterial.ID: RawMaterial]? = nil,
                wips: [WorkInProgress.ID: WorkInProgress]? = nil,
                finishedGoods: [FinishedGood.ID: FinishedGood]? = nil,
                clients: [Client.ID: Client]? = nil,
                cashAccount: CashAccount? = nil,
                revenueAccount: RevenueAccount? = nil,
                taxLiabilities: TaxLiabilities? = nil
    ) {
        self.rawMaterials = rawMaterials ?? [:]
        self.wips = wips ?? [:]
        self.finishedGoods = finishedGoods ?? [:]
        self.clients = clients ?? [:]
        self.cashAccount = cashAccount ?? .init()
        self.revenueAccount = revenueAccount ?? .init()
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
    }

}
