public struct DepreciationExpenses: SimpleAccount {
    public static var kind: AccountKind = .active
    public static var accountGroup: AccountGroup = .incomeStatement(.expense(.depreciation))

    public var amount: Double = 0

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension DepreciationExpenses: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "DepreciationExpenses(\(amount))"
    }
}
