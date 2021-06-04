import Foundation
import Tagged

public struct FinishedGood: Product {
    public let id: Tagged<Self, UUID>
    public let name: String

    public var inventory: InventoryAccount

    /// `Cost of Goods Sold`
    /// Cost of goods sold is the accumulated total of all costs used to create a product or service,
    /// which has been sold.
    ///
    /// These costs fall into the general sub-categories of `direct labor`,
    /// `materials`, and `overhead`. In a service business, the cost of goods sold is considered
    /// to be the `labor`, `payroll taxes`, and `benefits` of those people who generate
    /// billable hours (though the term may be changed to "cost of services"). In a retail or wholesale
    /// business, the cost of goods sold is likely to be merchandise that was bought from a manufacturer.
    /// https://www.accountingtools.com/articles/2017/5/4/cost-of-goods-sold
    ///
    /// COGS is recognized in the same period as the related revenue, so that revenues and
    /// related expenses are always matched against each other (the matching principle);
    /// the result should be recognition of the proper amount of profit or loss in an accounting period.
    /// https://www.accountingtools.com/articles/what-is-cogs-cost-of-goods-sold.html
    public var cogs: Account

    public func cost() -> Double? {
        inventory.cost()
    }
    public init(id: UUID = UUID(),
                name: String,
                initialInventoryQty qty: Int,
                initialInventoryValue amount: Double,
                initialCOGS cogs: Double
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.name = name
        self.inventory = .init(type: .finishedGoods, qty: qty, amount: amount)
        self.cogs = .init(group: .cogs, amount: cogs)
    }

    public init(id: UUID = UUID(), name: String) {
        self.init(id: id,
                  name: name,
                  initialInventoryQty: 0,
                  initialInventoryValue: 0,
                  initialCOGS: 0
        )
    }

}

extension FinishedGood: CustomStringConvertible {
    public var description: String {
        """
        FinishedGood '\(name)'
        \tInventory: \(inventory)
        \tCOGS: \(cogs))
        """
    }
}
