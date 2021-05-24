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
public struct COGS: SimpleAccount {
    public static let kind: AccountKind = .active
    public static let accountGroup: AccountGroup = .incomeStatement(.expense(.cogs))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension COGS: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "COGS(\(amount))"
    }
}
