// MARK: Business Operations

/// A `transaction` is a business event that has a monetary impact on an entity's
/// financial statements, and is recorded as an entry in its accounting records.
/// Examples of transactions are as follows:
///
///     Paying a supplier for services rendered or goods delivered.
///     Paying a seller with cash and a note in order to obtain ownership
///      of a property formerly owned by the seller.
///     Paying an employee for hours worked.
///     Receiving payment from a customer in exchange for goods or services delivered.
///
public extension Books {

    /// `Booking Revenue` occurs when Finished Goods are shipped to Client:
    /// delivery started by goods leaving the warehouse.
    ///
    /// NB: this could be slightly more nuanced,
    /// [see example](https://www.accountingtools.com/articles/revenue-recognition.html),
    ///
    /// but that is not significant in our case of financial modeling.
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
    /// [Source 1](https://www.accountingtools.com/articles/sales-journal-entry.html)
    ///
    /// [Source 2](https://saldovka.com/provodki/tovary/prodazha-tovara.html)
    ///
    /// Net revenue (excluding VAT) minus COGS is a financial result of this operation (sale).
    ///
    /// - Throws: If incorrect order type is used, or unknown `Client`, unknown `Finished Good`,
    /// if cost of finished good can't be determined, or accounts in this transaction do not have
    /// sufficient balance.
    mutating func bookRevenue(for order: SalesOrder) throws {
        guard order.orderType == .bookRevenue else {
            throw BooksError.incorrectOrderType
        }

        let clientID = order.clientID
        guard var client = clients[clientID] else {
            throw BooksError.unknownClient
        }

        let finishedGoodID = order.finishedGoodID
        guard var finishedGood = finishedGoods[finishedGoodID] else {
            throw BooksError.unknownFinishedGood
        }

        guard let cost = finishedGood.cost() else {
            throw BooksError.costOfProductNotDefined
        }

        // backup is needed: transaction #2 could fail after transaction #1
        let ledgerBackup = ledger

        do {
            // MARK: Ledger

            /// 1. For amount including Value Added Tax (VAT):
            ///
            ///     - debit Accounts Receivable (Client or Channel).
            ///     - credit Revenue (Product).
            ///
            try doubleEntry(debit: .receivables,
                            credit: .revenue,
                            amount: order.amountWithTax)

            /// 2. For amount of VAT:
            ///
            ///     - debit Revenue (Product).
            ///     - credit Tax Liabilities Account (General Ledger).
            ///
            try doubleEntry(debit: .revenue,
                            credit: .taxesPayable,
                            amount: order.tax)

            /// 3. For amount of Cost of Goods Sold (COGS):
            ///
            ///     - debit COGS (Product).
            ///     - credit Inventory (Product).
            ///
            let cogs = Double(order.qty) * cost

            try doubleEntry(debit: .cogs,
                            credit: .finishedInventory,
                            amount: cogs)

            // MARK: Journaling

            // local var change; throws if ...
            try client.receivables.debit(amount: order.amountWithTax)

            // local var change; throws if ...
            try finishedGood.cogs.debit(amount: cogs)
            try finishedGood.inventory.credit(order: order)

            // if no error thrown safe to update clients
            clients[clientID] = client
            // if no error thrown safe to update finished goods
            finishedGoods[finishedGoodID] = finishedGood
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
