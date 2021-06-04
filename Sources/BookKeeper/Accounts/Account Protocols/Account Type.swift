/// `AccountTypeProtocol` defines `fantom types` with static properties
/// intended to be used with `Account<AccountType>`.
///
/// Motivation: prevent errors like setting cash account value to revenue account by
/// using different types:
/// `Account<Cash> and Account<Revenue>` respectively.
///
public protocol AccountTypeProtocol: Equatable {
    static var defaultName: String { get }
    static var kind: AccountKind { get }
    static var group: AccountGroup { get }
}

public enum AccountsReceivable: AccountTypeProtocol {
    public static var defaultName = "Accounts Receivable"
    public static let kind = AccountKind.active
    public static let group = AccountGroup.receivables
}

public enum VATReceivable: AccountTypeProtocol {
    public static var defaultName = "VAT Receivable"
    public static let kind = AccountKind.active
    public static let group = AccountGroup.vatReceivable
}

public enum Cash: AccountTypeProtocol {
    public static var defaultName = "Cash"
    public static let kind = AccountKind.active
    public static let group = AccountGroup.cash
}

/// `Cost of Goods Sold`
/// Cost of goods sold is the accumulated total of all costs used to create a product or service,
/// which has been sold.
///
/// These costs fall into the general sub-categories of `direct labor`, `materials`,
/// and `overhead`. In a service business, the cost of goods sold is considered
/// to be the `labor`, `payroll taxes`, and `benefits` of those people who generate
/// billable hours (though the term may be changed to "cost of services"). In a retail or wholesale
/// business, the cost of goods sold is likely to be merchandise that was bought from a manufacturer.
/// https://www.accountingtools.com/articles/2017/5/4/cost-of-goods-sold
///
/// COGS is recognized in the same period as the related revenue, so that revenues and
/// related expenses are always matched against each other (the matching principle);
/// the result should be recognition of the proper amount of profit or loss in an accounting period.
/// https://www.accountingtools.com/articles/what-is-cogs-cost-of-goods-sold.html
public enum COGS: AccountTypeProtocol {
    public static var defaultName = "COGS"
    public static let kind = AccountKind.active
    public static let group = AccountGroup.cogs
}

public enum DepreciationExpenses: AccountTypeProtocol {
    public static var defaultName = "Depreciation Expenses"
    public static let kind = AccountKind.active
    public static let group = AccountGroup.depreciationExpenses
}

/// `Accounts payable` is the aggregate amount of one's short-term obligations to pay
/// suppliers for products and services that were purchased on credit. If accounts payable
/// are not paid within the payment terms agreed to with the supplier, the payables are considered
/// to be in default, which may trigger a penalty or interest payment, or the revocation or
/// curtailment of additional credit from the supplier.
/// Other types of payables that are not considered accounts payable are wages payable and notes payable.
/// https://www.accountingtools.com/articles/2017/5/5/accounts-payable
/// https://www.accountingtools.com/articles/accounting-for-accounts-payable.html
/// https://www.accountingtools.com/articles/how-to-reconcile-accounts-payable.html
public enum AccountsPayable: AccountTypeProtocol {
    public static var defaultName = "Accounts Payable"
    public static let kind = AccountKind.passive
    public static let group = AccountGroup.payables
}

/// `Accumulated depreciation` is the total depreciation for a equipment that has been charged
/// to expense since that asset was acquired and made available for use. The accumulated depreciation
/// account is an asset account with a credit balance (also known as a contra asset account);
/// this means that it appears on the balance sheet as a reduction from the gross amount of equipment reported.
///
/// The amount of accumulated depreciation for an asset will increase over time, as depreciation continues
/// to be charged against the asset. The original cost of the asset is known as its `gross cost`,
/// while the original cost of the asset less the amount of accumulated depreciation and any impairment
/// is known as its `net cost` or `carrying amount`.
/// https://www.accountingtools.com/articles/what-is-accumulated-depreciation.html
public enum AccumulatedDepreciationEquipment: AccountTypeProtocol {
    public static var defaultName = "Accumulated Depreciation Equipment"
    public static let kind = AccountKind.passive
    // swiftlint:disable line_length
    public static let group = AccountGroup.accumulatedDepreciation
    // swiftlint:enable line_length
}

public enum TaxLiabilities: AccountTypeProtocol {
    public static var defaultName = "Tax Liabilities"
    public static let kind = AccountKind.passive
    public static let group = AccountGroup.taxesPayable
}

public enum Revenue: AccountTypeProtocol {
    public static var defaultName = "Revenue"
    public static let kind = AccountKind.passive
    public static let group = AccountGroup.revenue
}
