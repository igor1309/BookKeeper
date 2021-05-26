import Foundation

public struct FinishedGood: Product {
    #warning("change id to type safe id")
    public let id: UUID
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
    public var cogs: Account<COGS>

    public func cost() -> Double? {
        inventory.cost()
    }

    public init(id: UUID = UUID(),
                name: String,
                inventory: InventoryAccount = .init()
    ) {
        self.id = id
        self.name = name
        self.inventory = inventory
        self.cogs = .init(name: name)
    }

    #warning("this init conflicts. fix & write tests. see FinishedGoodTests")
    /// Failable initialiser that checks Account Kind and AccountGroup
//    public init?(id: UUID = UUID(),
//                 name: String,
//                 inventory: InventoryAccount = .init(),
//                 cogs: SimpleAccount
//    ) {
//        guard cogs.kind == .active,
//              cogs.group == AccountGroup.incomeStatement(.expense(.cogs)) else {
//            return nil
//        }
//
//        self.id = id
//        self.name = name
//        self.inventory = inventory
//        self.cogs = cogs
//    }

}

extension FinishedGood: CustomStringConvertible {
    public var description: String {
        """
        FinishedGood '\(name)'
        \tinventory: \(inventory)
        \tcogs: \(cogs))
        """
    }
}
