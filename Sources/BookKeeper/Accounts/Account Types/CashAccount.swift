public struct CashAccount: SimpleAccount {
    public static var kind: AccountKind = .active
    public static var accountGroup: AccountGroup = .balanceSheet(.asset(.currentAsset(.cash)))

    public var amount: Double = 0

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension CashAccount: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "CashAccount(\(amount))"
    }
}
