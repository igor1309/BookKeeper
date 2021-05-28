// MARK: - Business Operations
public extension Books {

    /// `Receive Cash` from Client.
    ///
    ///                              debit    credit
    ///     ----------------------------------------
    ///     Cash                       120
    ///     Accounts Receivable                  120
    ///
    ///
    mutating func receiveCash(_ amount: Double, from clientID: Client.ID) throws {
        let cashAccountBackup = cashAccount
        guard let receivablesBackup = clients[clientID]?.receivables else {
            throw BooksError.unknownClient
        }

        do {
            try cashAccount.debit(amount: amount)
            try clients[clientID]?.receivables.credit(amount: amount)
        } catch {
            // restore (undo)
            cashAccount = cashAccountBackup
            clients[clientID]?.receivables = receivablesBackup

            throw error
        }
    }

}
