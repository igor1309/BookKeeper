public struct EquipmentDepreciationAccount: SimpleAccount {
    public static var kind: AccountKind = .passive
    public static var accountGroup: AccountGroup = .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment)))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }

}

extension EquipmentDepreciationAccount: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "EquipmentDepreciationAccount(\(amount))"
    }
}
