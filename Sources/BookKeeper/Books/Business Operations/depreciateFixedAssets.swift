// MARK: - Business Operations
public extension Books {

    /// `Depreciate Fixed Assetes`
    /// Recording monthly depreciation for all fixed assets.
    mutating func depreciateFixedAssets() throws {
        for assetID in fixedAssets.keys {
            guard let asset = fixedAssets[assetID] else {
                fatalError("can't find fixed asset for existing fixed asset id \(assetID)")
            }

            // MARK: depreciationAmountPerMonth could be a method in fixed asset struct
            // with potentially different depreciation strategies
            #warning("encapsulate depreciation into Fixed Asset")
            let depreciationAmountPerMonth = asset.value / Double(asset.lifetime) / 12

            guard depreciationAmountPerMonth <= asset.carryingAmount else {
                throw BooksError.depreciationFail
            }

            // debit
            try depreciationExpensesAccount.debit(amount: depreciationAmountPerMonth)

            // credit
            fixedAssets[assetID]?.depreciation += depreciationAmountPerMonth
        }
    }
}
