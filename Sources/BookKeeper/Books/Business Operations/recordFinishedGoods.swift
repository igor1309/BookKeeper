// MARK: Business Operations

public extension Books {

    /// `Record Finished Goods`. Once the production facility has converted
    /// the work-in-process into completed goods, you then shift the cost of these materials
    /// into the finished goods account.
    ///
    ///                                  debit    credit
    ///     --------------------------------------------
    ///     Finished Goods Inventory       120
    ///     WIP Inventory                            120
    ///
    ///
    /// - Parameter order: Production Order with operation details.
    /// - Throws: If `Finished Good` is unknown, or `Work in Progress` is unknown,
    /// or `cost` can't be determined, or Work in Progress `inventory` balance is less than in order.
    mutating func recordFinishedGoods(for order: ProductionOrder) throws {
        guard case .recordFinishedGoods = order.orderType else {
            throw BooksError.incorrectOrderType
        }

        guard let amount = order.amount else {
            throw OrderProcessingError.noCost
        }

        let finishedGoodID = order.finishedGoodID
        let wipID = order.wipID

        guard var finishedGood = finishedGoods[finishedGoodID] else {
            throw BooksError.unknownFinishedGood
        }
        guard var workInProgress = wips[wipID] else {
            throw BooksError.unknownWorkInProgress
        }

        // backup
        let ledgerBackup = ledger

        do {
            // local var change; throws if ...
            try finishedGood.inventory.debit(order: order)
            // local var change; throws if ...
            try workInProgress.inventory.credit(order: order)

            try doubleEntry(debit: .finishedInventory,
                            credit: .wipsInventory,
                            amount: amount)

            // if no error thrown safe to update finished goods
            finishedGoods[finishedGoodID] = finishedGood
            // and work in progress
            wips[wipID] = workInProgress
        } catch {
            // restore if needed
            if ledger != ledgerBackup {
                ledger = ledgerBackup
            }

            throw error
        }
    }

}
