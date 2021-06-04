// MARK: Business Operations

public extension Books {

    /// `Purchase Raw Materials`
    /// Бухгалтерские проводки при покупке товара с постоплатой
    /// https://saldovka.com/provodki/tovary/pokupka-tovara-ili-uslugi.html
    ///
    ///                                 debit    credit
    ///     -------------------------------------------
    ///     Inventory                     100
    ///     VAT Receivable                 20
    ///     Accounts Payable (100+20)               120
    ///
    ///
    mutating func purchaseRawMaterial(for order: PurchaseOrder) throws {
        guard case let .purchaseRawMaterial(rawMaterial) = order.orderType else {
            throw BooksError.incorrectOrderType
        }

        guard var rawMaterial = rawMaterials[rawMaterial.id] else {
            throw BooksError.unknownRawMaterial
        }

        let supplierID = order.supplierID
        guard var supplier = suppliers[supplierID] else {
            throw BooksError.unknownSupplier
        }

        // backup is needed: transaction #2 could fail after transaction #1
        let ledgerBackup = ledger

        do {
            // local var change; throws if
            try rawMaterial.inventory.debit(order: order)
            // local var change; throws if supplier owes less than amount
            try supplier.payables.credit(amount: order.amountWithVAT)

            // transaction #1
            // 1. Поступили товары от поставщика. Стоимость товара без учета размера НДС
            //    дебет 41.01 Товары на складах
            //    кредит 60.01 Расчеты с поставщиками и подрядчиками
            try doubleEntry(debit: .rawInventory,
                            credit: .payables,
                            amount: order.amountExVAT)

            // transaction #2
            // 2. Выделение НДС из полной стоимости товара. Размер НДС
            //    дебет 19.03 НДС по приобретенным материально-производственным запасам
            //    кредит 60.01 Расчеты с поставщиками и подрядчиками
            // 3. Перенос НДС для возмещения из гос бюджета. Размер НДС
            //    дебет 68.02 - Налог на добавленную стоимость
            //    кредит 19.03 - НДС по приобретенным материально-производственным запасам
            // 2 и 3 объединяю
            try doubleEntry(debit: .vatReceivable,
                            credit: .payables,
                            amount: order.vat)

            // if no error thrown safe to update suppliers
            suppliers[supplierID] = supplier
            // and raw materials
            rawMaterials[rawMaterial.id] = rawMaterial
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
