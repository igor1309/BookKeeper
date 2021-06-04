// MARK: Business Operations

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
    /// НДС дебетуется по счету 19.01 - НДС при приобретении основных средств.
    /// Подчинен счету "НДС по приобретенным ценностям" (19).
    ///
    mutating func purchaseEquipment(supplierID: Supplier.ID,
                                    assetName name: String,
                                    lifetimeInYears: Int,
                                    amountExVAT: Double,
                                    vatRate: Double = 20/100
    ) throws {

        // input validation
        guard var supplier = suppliers[supplierID] else {
            throw BooksError.unknownSupplier
        }

        guard lifetimeInYears > 0 else { throw BooksError.incorrectLifetime }
        guard amountExVAT > 0 else { throw BooksError.nonPositiveAmount }
        guard vatRate >= 0 else { throw BooksError.negativeVAT }

        // backup is needed: transaction #2 could fail after transaction #1
        let ledgerBackup = ledger

        do {
            let vat = amountExVAT * vatRate

            // local var change; journal supplier change
            try supplier.payables.credit(amount: amountExVAT + vat)

            // transaction #1
            try doubleEntry(debit: .equipment,
                            credit: .payables,
                            amount: amountExVAT)

            // transaction #2
            try doubleEntry(debit: .vatReceivable,
                            credit: .payables,
                            amount: vat)

            // if no errors thrown, journal equipment
            let equipment: Equipment = .init(
                name: name,
                lifetime: lifetimeInYears,
                value: amountExVAT,
                vatRate: vatRate
            )
            equipments[equipment.id] = equipment

            // if no error thrown safe to update suppliers
            suppliers[supplierID] = supplier
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
