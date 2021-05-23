/// Active accounts are those that account for property.
/// Passive accounts are those that reflect liabilities or sources.
/// There are also a number of accounts that can be both active
/// and passive at the same time, for example profit (recorded
/// on the credit of the account) and loss (debit of) account.
public enum AccountKind: Hashable, CaseIterable {
    case active, passive, bothActivePassive
}
