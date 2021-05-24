/// `Accounts payable` is the aggregate amount of one's short-term obligations to pay
/// suppliers for products and services that were purchased on credit. If accounts payable
/// are not paid within the payment terms agreed to with the supplier, the payables are considered
/// to be in default, which may trigger a penalty or interest payment, or the revocation or
/// curtailment of additional credit from the supplier.
/// Other types of payables that are not considered accounts payable are wages payable and notes payable.
/// https://www.accountingtools.com/articles/2017/5/5/accounts-payable
/// https://www.accountingtools.com/articles/accounting-for-accounts-payable.html
/// https://www.accountingtools.com/articles/how-to-reconcile-accounts-payable.html
public struct AccountsPayable: SimpleAccount {
    public static var kind: AccountKind = .passive
    public static var accountGroup: AccountGroup = .balanceSheet(.liability(.currentLiability(.accountsPayable)))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }

}

extension AccountsPayable: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "AccountsPayable(\(amount))"
    }
}
