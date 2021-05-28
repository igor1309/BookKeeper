// MARK: - Business Operations
public extension Books {

    /// `Record Finished Goods`
    /// Once the production facility has converted the work-in-process into completed goods,
    /// you then shift the cost of these materials into the finished goods account.
    ///
    ///                                  debit    credit
    ///     --------------------------------------------
    ///     Finished Goods Inventory       120
    ///     WIP Inventory                            120
    ///
    ///
    mutating func recordFinishedGoods(for order: ProductionOrder) throws {
        guard case .recordFinishedGoods(_) = order.orderType else {
            throw BooksError.incorrectOrderType
        }

        let finishedGoodID = order.finishedGoodID
        let wipID = order.wipID

        /// `Save State`
        /// See comment for function bookRevenue(for:)
        guard let finishedGoodsInventoryBackup = finishedGoods[finishedGoodID]?.inventory else {
            throw BooksError.unknownFinishedGood
        }
        guard let wipsInventoryBackup = wips[wipID]?.inventory else {
            throw BooksError.unknownWorkInProgress
        }

        do {
            try finishedGoods[finishedGoodID]?.inventory.debit(order: order)
            try wips[wipID]?.inventory.credit(order: order)
        } catch let error {
            /// `restore` to before-state (`undo` changes)
            finishedGoods[finishedGoodID]?.inventory = finishedGoodsInventoryBackup
            wips[wipID]?.inventory = wipsInventoryBackup

            throw error
        }
    }
}
