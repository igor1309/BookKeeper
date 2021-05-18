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
    var group: AccountGroup { Self.accountGroup }

    func balance() -> Double {
        return amount
    }
}

public protocol SimpleAccount: AccountProtocol {
    mutating func debit(amount: Double)
    mutating func credit(amount: Double)
}

public extension SimpleAccount {
    mutating func debit(amount: Double) {
        self.amount += amount
    }

    mutating func credit(amount: Double) {
        self.amount -= amount
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
