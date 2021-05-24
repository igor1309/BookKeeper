/// `Accumulated depreciation` is the total depreciation for a fixed asset that has been charged
/// to expense since that asset was acquired and made available for use. The accumulated depreciation
/// account is an asset account with a credit balance (also known as a contra asset account);
/// this means that it appears on the balance sheet as a reduction from the gross amount of fixed assets reported.
/// 
/// The amount of accumulated depreciation for an asset will increase over time, as depreciation continues
/// to be charged against the asset. The original cost of the asset is known as its `gross cost`,
/// while the original cost of the asset less the amount of accumulated depreciation and any impairment
/// is known as its `net cost` or `carrying amount`.
/// https://www.accountingtools.com/articles/what-is-accumulated-depreciation.html
public struct AccumulatedDepreciation: SimpleAccount {
    public static var kind: AccountKind = .passive
    public static var accountGroup: AccountGroup = .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment)))

    public var amount: Double

    public init(amount: Double = 0) {
        self.amount = amount
    }
}

extension AccumulatedDepreciation: CustomStringConvertible {
    #warning("kind and accountGroup properties are not used in description")
    public var description: String {
        "AccumulatedDepreciation(\(amount))"
    }
}
