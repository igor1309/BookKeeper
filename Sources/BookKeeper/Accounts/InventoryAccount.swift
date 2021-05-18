/// `Inventory Account`
///
/// Inventory Accounting Topics
/// https://www.accountingtools.com/summary-inventory-accounting
///
/// Journal entries for inventory transactions — AccountingTools
/// https://www.accountingtools.com/articles/2017/5/13/journal-entries-for-inventory-transactions
///
public struct InventoryAccount: AccountProtocol {
    public static let kind: AccountKind = .active
    public static let accountGroup: AccountGroup = .balanceSheet(.asset(.currentAsset(.inventory)))

    public var qty: Int
    public var amount: Double

    public init(qty: Int = 0, amount: Double = 0) {
        self.qty = qty
        self.amount = amount
    }
}

extension InventoryAccount: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "Inventory(amount: \(amount), qty: \(qty))"
    }
}

extension InventoryAccount {
    public var isEmpty: Bool { qty == 0 }

    public func cost() -> Double? {
        /// Note:
        ///
        ///     For modeling we allow qty, amount and cost  be negative
        ///
        guard qty != 0 else { return nil }

        return amount / Double(qty)
    }
}

// MARK: - Order Processing
#warning("finish with documentation - you can do better")
extension InventoryAccount: OrderProcessingAccount {
    public enum OrderProcessingError: Error {
        case wrongOrderType
        case emptyInventoryHasNoCost
    }

    /// `Debit`.
    /// Inventory Account is `active` account hence `increase` is recorded by `debit` on the account.
    /// The reasons for `inventory increase` are:
    ///
    ///     - new products were manufactured and moved from production to warehouse, this is handled by credit(inventoryOrder:)
    ///     - sales return, this is handled by credit(salesOrder:)
    ///
    /// `Production order`
    /// When finished Goods are moved from production floor
    ///
    public mutating func debit<Order: OrderProtocol>(order: Order) throws {
        switch order.orderType {
            case .salesReturn(let cost),
                 .produced(let cost),
                 .recordFinishedGoods(let cost):
                let amount = Double(order.qty) * cost
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
            case .bookRevenue, .trashed:
                guard let cost = cost() else {
                    throw OrderProcessingError.emptyInventoryHasNoCost
                }

                let amount = Double(order.qty) * cost
                self.amount -= amount
                self.qty -= order.qty

            case .recordFinishedGoods(let cost):
                let amount = Double(order.qty) * cost
                self.amount -= amount
                self.qty -= order.qty

            default:
                throw OrderProcessingError.wrongOrderType
        }
    }

}
