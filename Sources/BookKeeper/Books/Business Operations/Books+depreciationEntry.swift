// MARK: - Business Operations
public extension Books {
    /// Recording monthly depreciation for all fixed assets
    mutating func depreciationEntry() throws {
        for assetID in fixedAssets.keys {
            guard let asset = fixedAssets[assetID] else {
                fatalError("can't find fixed asset for existing fixed asset id \(assetID)")
            }

            // MARK: depreciationAmountPerMonth could be a method in fixed asset struct
            // with potentially different depreciation strategies
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
