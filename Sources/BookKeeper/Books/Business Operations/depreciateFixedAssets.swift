// MARK: - Business Operations
public extension Books {

    /// `Depreciate Fixed Assetes`
    /// Recording monthly depreciation for all fixed assets.
    ///
    ///                                debit    credit
    ///     ------------------------------------------
    ///     Depreciation Expenses        120
    ///     Fixed Asset Depreciation               120
    ///
    ///
    mutating func depreciateFixedAssets() throws {
        for assetID in fixedAssets.keys {
            guard let asset = fixedAssets[assetID] else {
                fatalError("can't find fixed asset for existing fixed asset id \(assetID)")
            }

            guard asset.depreciationAmountPerMonth <= asset.carryingAmount else {
                throw BooksError.depreciationFail
            }

            // debit
            try depreciationExpensesAccount.debit(amount: asset.depreciationAmountPerMonth)

            // kinda credit
            fixedAssets[assetID]?.depreciation += asset.depreciationAmountPerMonth
        }
    }

}
