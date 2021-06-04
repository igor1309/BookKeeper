// MARK: Business Operations

public extension Books {

    /// `Depreciate Fixed Assets`
    /// Recording monthly depreciation for all equipment.
    ///
    ///                                debit    credit
    ///     ------------------------------------------
    ///     Depreciation Expenses        120
    ///     Fixed Asset Depreciation               120
    ///
    ///
    mutating func depreciateEquipment() throws {
        for assetID in equipments.keys {
            guard var asset = equipments[assetID] else {
                fatalError("can't find equipment for existing equipment id \(assetID)")
            }

            // backup is not needed here
            // but backing up to be consistent with all business operations
            let ledgerBackup = ledger

            do {
                // local var change; throws if carryingAmount of the asset is less than depreciationAmountPerMonth
                try asset.depreciate()

                // doubleEntry is self-cleaning, no need to backup
                try doubleEntry(debit: .depreciationExpenses,
                                credit: .accumulatedDepreciation,
                                amount: asset.depreciationAmountPerMonth)

                // if no error thrown safe to update equipment
                equipments[assetID] = asset
            } catch {
                // restore if needed
                if ledger != ledgerBackup {
                    ledger = ledgerBackup
                }

                throw error
            }
        }
    }

}
