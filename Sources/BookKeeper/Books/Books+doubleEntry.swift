// MARK: - Double Entry

public extension Books {

    /// Perform debit and credit operation on the pair of accounts.
    /// `Self-cleaning`, i.e. in case of an error returns accounts to previous state.
    ///
    /// The `Double Entry` concept is an essential ingredient of the accounting system.
    /// It states that every accounting transaction must be recorded using opposing entries
    /// in two different accounts.
    /// Under the double entry system, all accounting entries must satisfy the accounting equation, which is:
    ///
    ///     Assets = Liabilities + Equity
    ///
    /// When entries are made in the double entry system, there must be a debit entry and a credit entry
    /// into the general ledger. A debit records an entry on the left side of an account ledger,
    /// while a credit records an entry on the right side of the ledger. The totals for all debit entries made
    /// must always match the totals for all credit entries made; when this is the case, an entry is said
    ///  to be in balance.
    /// - Parameters:
    ///   - debit: Account group to be debited.
    ///   - credit: Account group to be credited.
    ///   - amount: Transaction amount.
    /// - Throws: Error if debit or credit operation fails, for example if balance is not sufficient.
    mutating func doubleEntry(debit: AccountGroup, credit: AccountGroup, amount: Double) throws {
        let debitAccountBackup = ledger[debit]
        let creditAccountBackup = ledger[credit]

        do {
            // get stored account or create new
            var debitAccount = ledger[debit, default: .init(group: debit)]
            var creditAccount = ledger[credit, default: .init(group: credit)]

            // try double entry (debit-credit)
            try debitAccount.debit(amount: amount)
            try creditAccount.credit(amount: amount)

            // update accounts if no errors thrown
            ledger[debit] = debitAccount
            ledger[credit] = creditAccount
        } catch {
            // restore backup if any account operation (debit or credit) fails
            ledger[debit] = debitAccountBackup
            ledger[credit] = creditAccountBackup

            throw error
        }
    }
}
