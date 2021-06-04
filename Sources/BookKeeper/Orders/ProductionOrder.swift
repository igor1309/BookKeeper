/// `Production Order`
///
public struct ProductionOrder: OrderProtocol {
    public var cost: Double? {
        if case .recordFinishedGoods(let cost) = orderType {
            return cost
        } else {
            return nil
        }
    }

    //    public enum OrderType: Equatable {
    //        case recordFinishedGoods(cost: Double)
    //        case someOtherType
    //    }

    public let orderType: OrderType

    public let finishedGoodID: FinishedGood.ID
    public let wipID: WorkInProgress.ID

    public let qty: Int

    public init(orderType: OrderType,
                finishedGoodID: FinishedGood.ID,
                workInProgressID: WorkInProgress.ID,
                finishedGoodQty qty: Int
    ) {
        self.orderType = orderType
        self.finishedGoodID = finishedGoodID
        self.wipID = workInProgressID
        self.qty = qty
    }
}

extension ProductionOrder: CustomStringConvertible {
    public var description: String {
        "Production Order(\(orderType): \(qty))"
    }
}
