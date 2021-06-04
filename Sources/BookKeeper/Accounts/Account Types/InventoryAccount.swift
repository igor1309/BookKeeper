/// `Inventory Account`
///
/// Inventory Accounting Topics
/// https://www.accountingtools.com/summary-inventory-accounting
///
/// Journal entries for inventory transactions — AccountingTools
/// https://www.accountingtools.com/articles/2017/5/13/journal-entries-for-inventory-transactions
///
public struct InventoryAccount: AccountProtocol {
    public typealias InventoryType = AccountGroup.BalanceSheet.Asset.CurrentAsset.Inventory

    public let kind: AccountKind = .active
    public var type: InventoryType

    #warning("make qty private(set)")
    public var qty: Int
    internal var amount: Double

    public init(type: InventoryType,
                qty: Int,
                amount: Double
    ) {
        self.type = type
        self.qty = qty
        self.amount = amount
    }

    public init(type: InventoryType) {
        self.type = type
        self.qty = 0
        self.amount = 0
    }

    public var balance: Double { amount }
}

extension InventoryAccount {
    public var group: AccountGroup {
        .balanceSheet(.asset(.currentAsset(.inventory(type))))
    }
}

extension InventoryAccount: CustomStringConvertible {
    public var description: String {
        "Inventory(qty: \(qty), amount: \(amount))"
    }
}

extension InventoryAccount {
    public var isEmpty: Bool { qty == 0 }

    public func cost() -> Double? {
        /// Note:
        ///
        ///     For modeling we allow qty, amount and cost to be negative
        ///
        guard qty != 0 else { return nil }

        return amount / Double(qty)
    }
}

// MARK: - Order Processing

extension InventoryAccount: OrderProcessingAccount {

    /// `Debit`.
    /// Inventory Account is `active` account hence `increase` is recorded by `debit` on the account.
    /// The reasons for `inventory increase` are:
    ///
    ///     - new products were manufactured and moved from production to warehouse,
    ///     this is handled by credit(inventoryOrder:)
    ///     - sales return, this is handled by credit(salesOrder:)
    ///
    /// `Production order`
    /// When finished Goods are moved from production floor
    ///
    public mutating func debit<Order: OrderProtocol>(order: Order) throws {

        switch order.orderType {
            case .salesReturn,
                 .produced,
                 .recordFinishedGoods,
                 .purchaseRawMaterial:
                guard let amount = order.amount else {
                    throw OrderProcessingError.noCost
                }

                self.amount += amount
                self.qty += order.qty

            default:
                throw OrderProcessingError.wrongOrderType
        }
    }

    /// `Credit`
    /// `Sales Order`
    ///
    /// `Inventory order` credit. Inventory is credited when:
    ///
    ///     - revenue is booked, this is handled by credit(salesOrder:)
    ///     - products are utilized due to quality issues, this is handled by credit(inventoryOrder:)
    ///
    /// `Production order`
    /// When finished Goods are moved from production floor
    ///
    public mutating func credit<Order: OrderProtocol>(order: Order) throws {

        switch order.orderType {
            case .bookRevenue,
                 .trash:

                guard let cost = cost() else {
                    throw OrderProcessingError.noCost
                }

                let amount = cost * Double(order.qty)
                self.amount -= amount
                self.qty -= order.qty

            /// debiting and crediting recordFinishedGoods (inventory operation)
            /// is different: we use order amount for debit
            /// but for credit we should use cost from inventory account
            case .recordFinishedGoods:
                guard let cost = cost() else {
                    throw OrderProcessingError.noCost
                }

                self.amount -= Double(order.qty) * cost
                self.qty -= order.qty

            default:
                throw OrderProcessingError.wrongOrderType
        }
    }

}
