import Foundation

extension Sequence {
    /// Returns an array containing the properties for the given keyPath over the sequence’s elements.
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}

public extension Dictionary {
    /// Returns a Boolean value indicating whether the property of Dictionary Value at a given keyPath contains given value.
    /// - Parameters:
    ///   - prop: value to look for.
    ///   - keyPath: keyPath.
    /// - Returns: `true` if the Dictionary Values contains an element with property of a value (at keyPath); otherwise, `false`.
    func contains<T: Equatable>(_ prop: T, at keyPath: KeyPath<Value, T>) -> Bool {
        values.contains { $0[keyPath: keyPath] == prop }
    }

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
}

public extension Array {
    /// Return dictionary of array elements keyed by keyPath.
    func keyedBy<T: Hashable>(keyPath: KeyPath<Element, T>) -> Dictionary<T, Element> {
        Dictionary(uniqueKeysWithValues: self.map { ($0[keyPath: keyPath], $0) })
    }
}

public extension Dictionary where Key == AccountGroup, Value: AccountProtocol {
    var balanceSheet:   Self { filter { $0.key.isBalanceSheet } }
    var assets:         Self { filter { $0.key.isAsset } }
    var liabilities:    Self { filter { $0.key.isLiability } }
    var currentAssets:  Self { filter { $0.key.isCurrentAsset } }

    var balance: Double {
        values.reduce(0, { $0 + ($1.kind == .active ? 1 : -1) * $1.balance })
    }
}
