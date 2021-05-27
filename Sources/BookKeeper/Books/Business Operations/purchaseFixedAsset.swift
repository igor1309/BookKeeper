// MARK: - Business Operations
public extension Books {

    /// `Purchase Fixed Asset`
    mutating func purchaseFixedAsset(name: String, lifetimeInYears: Int, amount: Double) throws {
        
        guard lifetimeInYears > 0 else {
            throw BooksError.incorrectLifetime
        }

        guard amount > 0 else {
            throw BooksError.nonPositiveAmount
        }

        // kinda debit
        let fixedAsset = FixedAsset(name : name, lifetime: lifetimeInYears, value: amount)
        fixedAssets[fixedAsset.id] = fixedAsset

        // credit
        try payables.credit(amount: amount)
    }
}
