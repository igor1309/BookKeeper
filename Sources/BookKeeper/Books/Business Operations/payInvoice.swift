// MARK: - Business Operations
public extension Books {

    /// `Pay Invoice`
    mutating func payInvoice(amount: Double) throws {
        
        try doubleEntry(debitAccount: &payables,
                        creditAccount: &cashAccount,
                        amount: amount)
    }

}
