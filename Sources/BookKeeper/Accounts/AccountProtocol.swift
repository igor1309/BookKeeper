import Foundation

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

public protocol SimpleAccount: AccountProtocol {
    mutating func debit(amount: Double) throws
    mutating func credit(amount: Double) throws
}

public enum AccountError: Error, Equatable {
    case insufficientBalance
    case negativeAmount
}

public extension SimpleAccount {
    mutating func debit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                self.amount += amount
            case .passive:
                if self.amount < amount {
                    throw AccountError.insufficientBalance
                } else {
                    self.amount -= amount
                }
        }
    }

    mutating func credit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                if self.amount < amount {
                    throw AccountError.insufficientBalance
                } else {
                    self.amount -= amount
                }
            case .passive:
                self.amount += amount
        }
    }
}

public protocol SalesProcessingAccount: AccountProtocol {
    mutating func debit(salesOrder: SalesOrder) throws
    mutating func credit(salesOrder: SalesOrder) throws
}

public protocol OrderProcessingAccount: AccountProtocol {
    mutating func debit<Order: OrderProtocol>(order: Order) throws
    mutating func credit<Order: OrderProtocol>(order: Order) throws
}
