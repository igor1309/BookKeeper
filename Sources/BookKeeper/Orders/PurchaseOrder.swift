/// `Purchase Order`
///
public struct PurchaseOrder: OrderProtocol {
    public let supplierID: Supplier.ID
    public var orderType: OrderType

    public var qty: Int
    public var priceExTax: Double

    public var cost: Double? { priceExTax }
    public var vatRate: Double

    public var vat: Double { vatRate * amountExVAT }
    public var amountExVAT: Double { Double(qty) * priceExTax }
    public var amountWithVAT: Double { amountExVAT + vat }

    public init(supplierID: Supplier.ID,
                orderType: OrderType,
                qty: Int,
                priceExTax: Double,
                vatRate: Double
    ) {
        self.supplierID = supplierID
        self.orderType = orderType
        self.qty = qty
        self.priceExTax = priceExTax
        self.vatRate = vatRate
    }
}
