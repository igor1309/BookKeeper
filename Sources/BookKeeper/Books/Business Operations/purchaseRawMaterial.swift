// MARK: - Business Operations
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

        guard rawMaterials[rawMaterial.id] != nil else {
            throw BooksError.unknownRawMaterial
        }

        let supplierID = order.supplierID
        guard suppliers[supplierID] != nil else {
            throw BooksError.unknownSupplier
        }

        // backup
        let rawMaterialsBackup = rawMaterials
        let suppliersBackup = suppliers
        let vatReceivableBackup = vatReceivable

        do {
            // 1. Поступили товары от поставщика. Стоимость товара без учета размера НДС
            //    дебет 41.01 Товары на складах
            //    кредит 60.01 Расчеты с поставщиками и подрядчиками
            try rawMaterials[rawMaterial.id]?.inventory.debit(order: order)
            // try payables.credit(amount: order.amountExVAT)
            try suppliers[supplierID]?.payables.credit(amount: order.amountExVAT)

            // 2. Выделение НДС из полной стоимости товара. Размер НДС
            //    дебет 19.03 НДС по приобретенным материально-производственным запасам
            //    кредит 60.01 Расчеты с поставщиками и подрядчиками

            // 3. Перенос НДС для возмещения из гос бюджета. Размер НДС
            //    дебет 68.02 - Налог на добавленную стоимость
            //    кредит 19.03 - НДС по приобретенным материально-производственным запасам

            // 2 и 3 объединяю
            try vatReceivable.debit(amount: order.vat)
            try suppliers[supplierID]?.payables.credit(amount: order.vat)
        } catch {
            // restore
            rawMaterials = rawMaterialsBackup
            suppliers = suppliersBackup
            // payables = payablesBackup
            vatReceivable = vatReceivableBackup

            throw error
        }
    }
}
