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
        guard let receivablesBackup = clients[clientID]?.receivables else {
            throw BooksError.unknownClient
        }
        guard let cogsBackup = finishedGoods[finishedGoodID]?.cogs else {
            throw BooksError.unknownFinishedGood
        }
        guard let inventoryBackup = finishedGoods[finishedGoodID]?.inventory else {
            throw BooksError.unknownFinishedGood
        }
        let revenueAccountBackup = revenueAccount
        let taxLiabilitiesBackup = taxLiabilities

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
            clients[clientID]?.receivables = receivablesBackup
            revenueAccount = revenueAccountBackup
            taxLiabilities = taxLiabilitiesBackup
            finishedGoods[finishedGoodID]?.cogs = cogsBackup
            finishedGoods[finishedGoodID]?.inventory = inventoryBackup

            throw error
        }
    }


}
