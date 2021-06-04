public protocol OrderProtocol: Equatable {
    // associatedtype OrderType: Equatable
    var orderType: OrderType { get }

    var qty: Int { get }
    var cost: Double? { get }
    var amount: Double? { get }
}

public extension OrderProtocol {
    var amount: Double? {
        guard let cost = cost else { return nil }

        return Double(qty) * cost
    }
}

public enum OrderType: Equatable {
    /// `Produced`
    /// This type of order is used when warehouse receives a stock of products from production.
    /// Production informs inventory about the cost of new product stock.
    case produced(cost: Double)

    /// `Trashed`
    /// This order type is used when products are utilized due to quality issues.
    case trash
    case recordFinishedGoods(cost: Double)
    case someOtherType
    case bookRevenue
    /// when products are returns we should provide cost (from previous records)
    case salesReturn(cost: Double)

    /// `Purchase`
    case purchaseRawMaterial(RawMaterial)
    case purchasePackaging// (Packaging)
}
