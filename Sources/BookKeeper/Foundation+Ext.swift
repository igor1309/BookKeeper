import Foundation

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}

public extension Dictionary {
    /// Returns sum for properties of dictionary values by keyPath.
    func sum<T>(for keyPath: KeyPath<Value, T>) -> T where T: Numeric {
        values.map(keyPath).reduce(0) { $0 + $1 }
    }

    /// Returns total balance for accounts (sum of accounts balances) that are properties of dictionary values.
    /// - Parameter keyPath: a keyPath to account.
    /// - Returns: sum of accounts balances.
    func totalBalance<T>(for keyPath: KeyPath<Value, T>) -> Double where T: AccountProtocol {

        values.map(keyPath).reduce(0) { $0 + $1.balance }
    }

    internal func totalBalanceIsZero<T>(for keyPath: KeyPath<Value, T>) -> Bool where T: AccountProtocol {

        totalBalance(for: keyPath) == 0
    }

    internal func combined<T>(_ keyPath: KeyPath<Value, Account<T>>) -> Account<T> where T: AccountTypeProtocol {

        Account(name: "Combined \(T.defaultName)",
                amount: totalBalance(for: keyPath))
    }
}
