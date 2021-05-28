// MARK: - Business Operations
public extension Books {

    /// `Pay Invoice`
    ///
    ///                          debit    credit
    ///     ------------------------------------
    ///     Accounts Payable       120
    ///     Cash                             120
    ///
    ///
    mutating func payInvoice(supplierID: Supplier.ID, amount: Double) throws {

        guard suppliers[supplierID] != nil else {
            throw BooksError.unknownClient
        }

        // backup
        let suppliersBackup = suppliers
        let cashAccountBackup = cashAccount

        do {
            try suppliers[supplierID]?.payables.debit(amount: amount)
            try cashAccount.credit(amount: amount)
        } catch {
            // restore
            suppliers = suppliersBackup
            cashAccount = cashAccountBackup

            throw error
        }
    }

}
