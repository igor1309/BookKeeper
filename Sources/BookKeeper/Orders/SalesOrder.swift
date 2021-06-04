/// `Sales Order`
/// Sales order is used to record sales operations. Main types are:
///
///     - booking revenue
///     - sales return
///
public struct SalesOrder: OrderProtocol {
    public var cost: Double? {
        #warning("not clear here: getting cost from order type or from order.priceExTax ???")
        switch orderType {
            case .bookRevenue:
                return priceExTax
            case .purchaseRawMaterial:
                return priceExTax
            case .purchasePackaging:
                return priceExTax
            case let .produced(cost):
                return cost
            case let .recordFinishedGoods(cost):
                return cost
            case let .salesReturn(cost):
                return cost
            default:
                return nil
        }
    }

    //    public enum OrderType: Equatable {
    //        case bookRevenue
    //        /// when products are returns we should provide cost (from previous records)
    //        case salesReturn(cost: Double)
    //    }

    public let orderType: OrderType
    public let clientID: Client.ID
    public let finishedGoodID: FinishedGood.ID
    #warning("qty should be Measurement")
    public let qty: Int
    public let priceExTax: Double
    public var taxRate: Double

    public var tax: Double { taxRate * amountExTax }
    public var amountExTax: Double { Double(qty) * priceExTax }
    public var amountWithTax: Double { amountExTax + tax }

    public init(orderType: OrderType,
                clientID: Client.ID,
                finishedGoodID: FinishedGood.ID,
                qty: Int,
                priceExTax: Double,
                taxRate: Double = 20 / 100
    ) {
        self.orderType = orderType
        self.clientID = clientID
        self.finishedGoodID = finishedGoodID
        self.qty = qty
        self.priceExTax = priceExTax
        self.taxRate = taxRate
    }
}

extension SalesOrder: CustomStringConvertible {
    public var description: String {
        "Sales Order(\(orderType) \(amountExTax): \(qty) @ \(priceExTax), tax: \(taxRate))"
    }
}
