// MARK: Business Operations

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
        guard var client = clients[clientID] else {
            throw BooksError.unknownClient
        }

        // backup is needed: transaction #2 could fail after transaction #1
        let ledgerBackup = ledger

        do {
            #warning("test so that both try fail")
            // 3. local var change; throws is client owes less than amount
            try client.receivables.credit(amount: amount)

            // 2. doubleEntry is self-cleaning, no need to backup
            try doubleEntry(debit: .cash,
                            credit: .receivables,
                            amount: amount)

            // 4. if no error thrown safe to update clients
            clients[clientID] = client
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
