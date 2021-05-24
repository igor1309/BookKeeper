public struct RevenueAccount: AccountProtocol {
    public static let kind: AccountKind = .passive
    public static let accountGroup: AccountGroup = .incomeStatement(.revenue)

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension RevenueAccount: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "RevenueAccount(\(amount))"
    }
}

// MARK: - Sales Order Processing
extension RevenueAccount: SalesProcessingAccount {

    /// Revenue is `passive account` hence revenue `deductions` are `debited` on the revenue account.
    /// Normal revenue deductions are:
    ///
    ///     - sales returns
    ///     - sales allowances
    ///     - sales discounts
    ///
    /// `Sales allowance` is a reduction in the price charged by a seller, due to a problem
    /// with the sold product or service, such as a quality problem, a short shipment, or an incorrect price).
    ///
    /// Those deductions normally recorded on Contra accounts.
    /// For more see https://www.accountingtools.com/articles/what-is-a-contra-account.html
    ///
    /// We have one extra, a special kind of deduction, `deduction of tax` (sales tax or
    /// value added tax), because booking revenue has 2 transactions involving revenue:
    ///
    ///     1. credit revenue for amount including tax
    ///     2. debit revenue for amount of tax
    ///
    /// We do not use contra accounts, we debit revenue.
    public mutating func debit(salesOrder order: SalesOrder) throws {

        switch order.orderType {
            case .bookRevenue:
                amount -= order.tax
            default:
                throw OrderProcessingError.wrongOrderType
        }
    }

    /// `Credit`
    /// Main reason to record revenue `increase` is revenue recognition,
    /// since Revenue is a `passive` account this is done by `credit` on it.
    public mutating func credit(salesOrder order: SalesOrder) throws {

        switch order.orderType {
            case .bookRevenue:
                amount += order.amountWithTax
            default:
                throw OrderProcessingError.wrongOrderType
        }
    }

}
