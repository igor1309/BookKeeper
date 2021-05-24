public struct TaxLiabilities: SimpleAccount {
    public static let kind: AccountKind = .passive
    public static let accountGroup: AccountGroup = .balanceSheet(.liability(.currentLiability(.taxesPayable)))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension TaxLiabilities: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "TaxLiabilities(\(amount))"
    }
}
