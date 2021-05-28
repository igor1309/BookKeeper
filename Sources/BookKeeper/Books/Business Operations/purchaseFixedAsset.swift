// MARK: - Business Operations
public extension Books {

    /// `Purchase Fixed Asset`
    ///
    ///                              debit    credit
    ///     ----------------------------------------
    ///     Fixed Asset*                100
    ///     VAT Receivable               20
    ///     Accounts Payable                     120
    ///
    ///
    /// https://saldovka.com/provodki/os
    ///
    /// В российском учете сначала дебетуется счет 08.04 Приобретение объектов основных средств
    /// на сумму стоимости приобретаемых ОС и затрат по транспортировке и монтажу. Затем счет 08.04
    /// кредитуется нв эти суммы и дебетуется счет 01.01 Основные средства в организации.
    /// https://saldovka.com/provodki/os/priobretenie-osnovnogo-sredstva.html
    /// НДС дебетуется по счету 19.01 - НДС при приобретении основных средств. Подчинен счету "НДС по приобретенным ценностям" (19).
    ///
    mutating func purchaseFixedAsset(supplierID: Supplier.ID,
                                     assetName name: String,
                                     lifetimeInYears: Int,
                                     amountExVAT: Double,
                                     vatRate: Double = 20/100
    ) throws {

        guard suppliers[supplierID] != nil else {
            throw BooksError.unknownSupplier
        }

        guard lifetimeInYears > 0 else {
            throw BooksError.incorrectLifetime
        }

        guard amountExVAT > 0 else {
            throw BooksError.nonPositiveAmount
        }

        guard vatRate >= 0 else {
            throw BooksError.negativeVAT
        }

        // backup
        let fixedAssetsBackup = fixedAssets
        let vatReceivableBackup = vatReceivable
        let suppliersBackup = suppliers

        do {
            // kinda debit fixed assets
            let fixedAsset: FixedAsset = .init(
                name: name,
                lifetime: lifetimeInYears,
                value: amountExVAT,
                vatRate: vatRate
            )
            fixedAssets[fixedAsset.id] = fixedAsset

            // debit VAT Receivable
            let vat = amountExVAT * vatRate
            try vatReceivable.debit(amount: vat)

            // credit payables
            let amount = amountExVAT + vat
            try suppliers[supplierID]?.payables.credit(amount: amount)
        } catch {
            // restore
            fixedAssets = fixedAssetsBackup
            vatReceivable = vatReceivableBackup
            suppliers = suppliersBackup

            throw error
        }
    }

}
