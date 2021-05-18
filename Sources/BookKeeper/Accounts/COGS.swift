public struct COGS: SimpleAccount {
    public static let kind: AccountKind = .active
    public static let accountGroup: AccountGroup = .incomeStatement(.expense(.cogs))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension COGS: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "COGS(\(amount))"
    }
}
