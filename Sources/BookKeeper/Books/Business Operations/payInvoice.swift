// MARK: Business Operations

public extension Books {

    /// `Pay Invoice`
    ///
    ///                          debit    credit
    ///     ------------------------------------
    ///     Accounts Payable       120
    ///     Cash                             120
    ///
    ///
    /// - Parameters:
    ///   - amount: Amount to be payed.
    ///   - supplierID: ID of the supplier to be payed to.
    /// - Throws: If unknown SupplierID is used or accounts have insufficient balances,
    /// like having less cash than is going to pay, or to pay more that owed to.
    mutating func payInvoice(amount: Double, to supplierID: Supplier.ID) throws {

        guard var supplier = suppliers[supplierID] else {
            throw BooksError.unknownSupplier
        }

        // backup is not needed here
        // but backing up to be consistent with all business operations
        let ledgerBackup = ledger

        do {
            // local var change; throws if supplier owes less than amount
            try supplier.payables.debit(amount: amount)

            // doubleEntry is self-cleaning, no need to backup
            try doubleEntry(debit: .payables,
                            credit: .cash,
                            amount: amount)

            // if no error thrown safe to update suppliers
            suppliers[supplierID] = supplier
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
