public struct AccountReceivable: SimpleAccount {
    public static let kind: AccountKind = .active
    public static let accountGroup: AccountGroup = .balanceSheet(.asset(.currentAsset(.accountsReceivable)))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension AccountReceivable: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "AccountReceivable(\(amount))"
    }
}
