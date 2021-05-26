// MARK: - Double Entry
public extension Books {
    
    /// Perform debit and credit operation on the pair of accounts.
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
    /// must always match the totals for all credit entries made; when this is the case, an entry is said to be in balance.
    /// - Parameters:
    ///   - debitAccount: Account to be debited.
    ///   - creditAccount: Account to be credited.
    ///   - amount: Transaction amount.
    /// - Throws: Error if debit or credit operation fails, for example if balance is not sufficient.
    func doubleEntry<T1, T2>(
        debitAccount: inout Account<T1>,
        creditAccount: inout Account<T2>,
        amount: Double
    ) throws where T1: AccountTypeProtocol, T2: AccountTypeProtocol{

        let debitAccountBackup = debitAccount
        let creditAccountBackup = creditAccount

        do {
            try debitAccount.debit(amount: amount)
            try creditAccount.credit(amount: amount)
        } catch {
            // restore backup if any account operation (debit or credit) fails
            debitAccount = debitAccountBackup
            creditAccount = creditAccountBackup

            throw error
        }
    }
}
