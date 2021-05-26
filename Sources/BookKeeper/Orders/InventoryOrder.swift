/// `Inventory Order`
/// When product is manufactured it goes to warehouse, to recored this operation we issue this inventory order.
public struct InventoryOrder: OrderProtocol {
    public var cost: Double? {
        if case .produced(let cost) = orderType {
            return cost
        } else {
            return nil
        }
    }

//    public enum OrderType: Equatable {
//        /// `Produced`
//        /// This type of order is used when warehouse receives a stock of products from production.
//        /// Production informs inventory about the cost of new product stock.
//        case produced(cost: Double)
//
//        /// `Trashed`
//        /// This order type is used when products are utilized due to quality issues.
//        case trashed
//    }

    public let orderType: OrderType

    public let finishedGoodID: FinishedGood.ID
    public let qty: Int

    public init(orderType: OrderType,
                finishedGoodID: FinishedGood.ID,
                qty: Int
    ) {
        self.orderType = orderType
        self.finishedGoodID = finishedGoodID
        self.qty = qty
    }
}


extension InventoryOrder: CustomStringConvertible {
    public var description: String {
        "Sales Order(\(orderType): \(qty))"
    }
}
