import Foundation

/// An `account` is a separate, detailed record associated with a specific asset, liability,
/// equity, revenue, expense, gain, or loss.
///
/// Examples of accounts are:
///     - Cash (asset account: normally a debit balance)
///     - Accounts receivable (asset account: normally a debit balance)
///     - Inventory (asset account: normally a debit balance)
///     - Fixed assets (asset account: normally a debit balance)
///     - Accounts payable (liability account: normally a credit balance)
///     - Accrued liabilities (liability account: normally a credit balance)
///     - Notes payable (liability account: normally a credit balance)
///     - Common stock (equity account: normally a credit balance)
///     - Retained earnings (equity account: normally a credit balance)
///     - Revenue - products (revenue account: normally a credit balance)
///     - Revenue - services (revenue account: normally a credit balance)
///     - Cost of goods sold (expense account: normally a debit balance)
///     - Wage expense (expense account: normally a debit balance)
///     - Utilities expense (expense account: normally a debit balance)
///     - Travel and entertainment (expense account: normally a debit balance)
///     - Gain on sale of asset (gain account: normally a credit balance)
///     - Loss on sale of asset (loss account: normally a debit balance)
public protocol AccountProtocol: Hashable {
    var amount: Double { get set }

    static var kind: AccountKind { get }
    static var accountGroup: AccountGroup { get }

    func balance() -> Double

    /// Each account should implement a function to calculate
    /// account balance for a given 'date', meaning "up to this date",
    /// expressed in money.
    /// Other possible "balances", that use non-money measurements
    /// (like inventory account balance as mass or volume
    /// or pieces measurement), should be implemented by those types.
    //  MARK: Note: we could have account currency as well, but that is not a feature for MVP.
    //  MARK: Time is difficult.
    // func balance(at date: Date) -> Double
    /// Function to calculate change of account money value for some time period.
    // func balance(for timeframe: Timeframe) -> Double
}

public extension AccountProtocol {
    var kind: AccountKind { Self.kind }
    var group: AccountGroup { Self.accountGroup }

    func balance() -> Double {
        return amount
    }
}
