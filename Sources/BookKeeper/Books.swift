import SwiftUI

public struct Books {
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]
    public var clients: [Client.ID: Client]

    public var revenueAccount: RevenueAccount
    public var taxLiabilities: TaxLiabilities

    public init(rawMaterials: [RawMaterial.ID: RawMaterial]? = nil,
                wips: [WorkInProgress.ID: WorkInProgress]? = nil,
                finishedGoods: [FinishedGood.ID: FinishedGood]? = nil,
                clients: [Client.ID: Client]? = nil,
                revenueAccount: RevenueAccount? = nil,
                taxLiabilities: TaxLiabilities? = nil
    ) {
        self.rawMaterials = rawMaterials ?? [:]
        self.wips = wips ?? [:]
        self.finishedGoods = finishedGoods ?? [:]
        self.clients = clients ?? [:]
        self.revenueAccount = revenueAccount ?? .init()
        self.taxLiabilities = taxLiabilities ?? .init()
    }

}

extension Books {
    public var isEmpty: Bool {
        rawMaterials.isEmpty
            && wips.isEmpty
            && finishedGoods.isEmpty
            && clients.isEmpty
            && revenueAccount.balance() == 0
            && taxLiabilities.balance() == 0
    }

    public func rawMaterialsAll() -> [RawMaterial.ID: RawMaterial] {
        rawMaterials
    }
    public func wipsAll() -> [WorkInProgress.ID: WorkInProgress] {
        wips
    }
    public func finishedGoodsAll() -> [FinishedGood.ID: FinishedGood] {
        finishedGoods
    }
    public func clientsAll() -> [Client.ID: Client] {
        clients
    }

    public func rawMaterial(forID id: RawMaterial.ID) -> RawMaterial? {
        rawMaterials[id]
    }
    public func workInProgress(forID id: WorkInProgress.ID) -> WorkInProgress? {
        wips[id]
    }
    public func finishedGood(forID id: FinishedGood.ID) -> FinishedGood? {
        finishedGoods[id]
    }
    public func client(forID id: Client.ID) -> Client? {
        clients[id]
    }

    public var revenueAccountBalance: Double {
        revenueAccount.balance()
    }
    public var taxLiabilitiesBalance: Double {
        taxLiabilities.balance()
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

// MARK: - Double Entry

public extension Books {
    func doubleEntry<Account1: SimpleAccount, Account2: SimpleAccount>(
        debitAccount: inout Account1,
        creditAccount: inout Account2,
        amount: Double
    ) throws {

        let debitBackup = debitAccount
        let creditBackup = creditAccount

        do {
            try debitAccount.debit(amount: amount)
            try creditAccount.credit(amount: amount)
        } catch {
            // restore backup if any account operation (debit or credit) fails
            debitAccount = debitBackup
            creditAccount = creditBackup

            throw error
        }
    }
}

// MARK: - Business Operations
public extension Books {
    /// `Booking Revenue` occurs when Finished Goods are shipped to Client:
    /// delivery started by goods leaving the warehouse.
    ///
    /// NB: this could be slightly more nuanced, see
    /// https://www.accountingtools.com/articles/revenue-recognition.html
    /// for example, but that is not significant in our case of financial modeling.
    ///
    /// To book revenue we record the following transactions:
    ///
    ///     1. For amount including Value Added Tax (VAT):
    ///     - debit Accounts Receivable (Client or Channel).
    ///     - credit Revenue (Product).
    ///
    ///     2. For amount of VAT:
    ///     - debit Revenue (Product).
    ///     - credit Tax Liabilities Account (General Ledger).
    ///
    ///     3. For amount of Cost of Goods Sold (COGS):
    ///     - debit COGS (Product).
    ///     - credit Inventory (Product).
    ///
    /// https://www.accountingtools.com/articles/sales-journal-entry.html
    /// https://saldovka.com/provodki/tovary/prodazha-tovara.html
    ///
    /// Net revenue (excluding VAT) minus COGS is a financial result of this operation (sale).
    ///
    mutating func bookRevenue(for order: SalesOrder) throws {
        guard order.orderType == .bookRevenue else {
            throw BooksError.incorrectOrderType
        }

        let clientID = order.clientID
        let finishedGoodID = order.finishedGoodID

        ///     - Note: more validation could be done here, for example check if inventory has enough stock
        ///             or we can leave it to debit and credit functions.

        /// `Save State`
        /// We `chain` transactions (double records to account pairs) to reflect business operations.
        /// And we use throwing functions for (some of) debit and credit account operations,
        /// so there could be a case where some functions perform ok and have a `side-effect`
        /// of recording new data (changing the  state), but one function (account operation) throws and
        /// invalidates the whole business operation. In a simple business operation chaining transactions
        /// would be recorded partially: some account would have a new state, some not.
        /// To handle this we store a `before-state` for every account we are going to change,
        /// and that states would be restored if any error occurs.
        #warning("""
            App State
            think about app state - this is a god example of saving state, attempting to modify state and restoring state in case of an error (automatic undo change)

            how to make state persistence better? how to save values of all properties so that there would be no errors if some property is not saved and thus cannot be restored?

            for example, look at Composable Architecture
            https://github.com/pointfreeco/swift-composable-architecture
            """)
        guard let receivablesBefore = clients[clientID]?.receivables else {
            throw BooksError.unknownClient
        }
        guard let cogsBefore = finishedGoods[finishedGoodID]?.cogs else {
            throw BooksError.unknownFinishedGood
        }
        guard let inventoryBefore = finishedGoods[finishedGoodID]?.inventory else {
            throw BooksError.unknownFinishedGood
        }
        let revenueAccountBefore = revenueAccount
        let taxLiabilitiesBefore = taxLiabilities

        do {
            /// 1. For amount including Value Added Tax (VAT):
            ///
            ///     - debit Accounts Receivable (Client or Channel).
            ///     - credit Revenue (Product).
            ///
            try clients[clientID]?.receivables.debit(amount: order.amountWithTax)
            try revenueAccount.credit(salesOrder: order)

            /// 2. For amount of VAT:
            ///
            ///     - debit Revenue (Product).
            ///     - credit Tax Liabilities Account (General Ledger).
            ///
            try revenueAccount.debit(salesOrder: order)
            try taxLiabilities.credit(amount: order.tax)

            guard let cost = finishedGoods[finishedGoodID]?.cost() else {
                print("cost of product is not defined")
                throw BooksError.costOfProductNotDefined
            }

            /// 3. For amount of Cost of Goods Sold (COGS):
            ///
            ///     - debit COGS (Product).
            ///     - credit Inventory (Product).
            ///
            let cogs = Double(order.qty) * cost
            try finishedGoods[finishedGoodID]?.cogs.debit(amount: cogs)
            try finishedGoods[finishedGoodID]?.inventory.credit(order: order)
        } catch let error {
            /// `restore` to before-state (`undo` changes)
            clients[clientID]?.receivables = receivablesBefore
            revenueAccount = revenueAccountBefore
            taxLiabilities = taxLiabilitiesBefore
            finishedGoods[finishedGoodID]?.cogs = cogsBefore
            finishedGoods[finishedGoodID]?.inventory = inventoryBefore

            throw error
        }
    }

    enum BooksError: Error {
        case incorrectOrderType
        case unknownClient
        case unknownFinishedGood
        case unknownWorkInProgress
        case costOfProductNotDefined
    }

    /// `Record Finished Goods`
    /// Once the production facility has converted the work-in-process into completed goods,
    /// you then shift the cost of these materials into the finished goods account.
    mutating func recordFinishedGoods(for order: ProductionOrder) throws {
        guard case .recordFinishedGoods(_) = order.orderType else {
            throw BooksError.incorrectOrderType
        }

        let finishedGoodID = order.finishedGoodID
        let wipID = order.wipID

        /// `Save State`
        /// See comment for function bookRevenue(for:)
        guard let finishedGoodsInventory = finishedGoods[finishedGoodID]?.inventory else {
            throw BooksError.unknownFinishedGood
        }
        guard let wipsInventory = wips[wipID]?.inventory else {
            throw BooksError.unknownWorkInProgress
        }

        do {
            try finishedGoods[finishedGoodID]?.inventory.debit(order: order)
            try wips[wipID]?.inventory.credit(order: order)
        } catch let error {
            /// `restore` to before-state (`undo` changes)
            finishedGoods[finishedGoodID]?.inventory = finishedGoodsInventory
            wips[wipID]?.inventory = wipsInventory

            throw error
        }
    }

}

// MARK: - Add
public extension Books {
    mutating func add(client: Client) {
        clients[client.id] = client
    }

    mutating func add(finishedGood: FinishedGood) {
        finishedGoods[finishedGood.id] = finishedGood
    }

    mutating func add(workInProgress wip: WorkInProgress) {
        wips[wip.id] = wip
    }

    mutating func add(rawMaterial: RawMaterial) {
        rawMaterials[rawMaterial.id] = rawMaterial
    }
}
