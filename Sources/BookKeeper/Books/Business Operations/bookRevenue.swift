// MARK: - Business Operations

/// A `transaction` is a business event that has a monetary impact on an entity's financial statements, and is recorded as an entry in its accounting records. Examples of transactions are as follows:
///
///     Paying a supplier for services rendered or goods delivered.
///     Paying a seller with cash and a note in order to obtain ownership of a property formerly owned by the seller.
///     Paying an employee for hours worked.
///     Receiving payment from a customer in exchange for goods or services delivered.
///
public extension Books {

    /// `Booking Revenue` occurs when Finished Goods are shipped to Client:
    /// delivery started by goods leaving the warehouse.
    ///
    /// NB: this could be slightly more nuanced, see
    /// https://www.accountingtools.com/articles/revenue-recognition.html
    /// for example, but that is not significant in our case of financial modeling.
    ///
    ///                                debit    credit
    ///     ------------------------------------------
    ///     Accounts Receivable          120
    ///     Revenue (120-20)                       100
    ///     Tax Liabilities                         20
    ///     ------------------------------------------
    ///     COGS                          80
    ///     Inventory                               80
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
        guard let receivablesBackup = clients[clientID]?.receivables else {
            throw BooksError.unknownClient
        }

        let finishedGoodID = order.finishedGoodID
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
            try revenueAccount.credit(amount: order.amountWithTax)

            /// 2. For amount of VAT:
            ///
            ///     - debit Revenue (Product).
            ///     - credit Tax Liabilities Account (General Ledger).
            ///
            try revenueAccount.debit(amount: order.tax)
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

            finishedGoods[finishedGoodID]?.cogs = cogsBackup
            finishedGoods[finishedGoodID]?.inventory = inventoryBackup

            revenueAccount = revenueAccountBackup
            taxLiabilities = taxLiabilitiesBackup

            throw error
        }
    }

}
