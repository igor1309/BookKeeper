public extension AccountGroup {
    static let cash: AccountGroup = .balanceSheet(.asset(.currentAsset(.cash)))
    static let receivables: AccountGroup = .balanceSheet(.asset(.currentAsset(.accountsReceivable)))
    static let vatReceivable: AccountGroup = .balanceSheet(.asset(.currentAsset(.vatReceivable)))
    static let equipment: AccountGroup = .balanceSheet(.asset(.propertyPlantEquipment(.equipment)))
    static let accumulatedDepreciation: AccountGroup = .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment)))

    static let payables: AccountGroup = .balanceSheet(.liability(.currentLiability(.accountsPayable)))
    static let taxesPayable: AccountGroup = .balanceSheet(.liability(.currentLiability(.taxesPayable)))
    static let loan: AccountGroup = .balanceSheet(.liability(.longtermLiability(.mortgageLoanPayable)))
    static let stocks: AccountGroup = .balanceSheet(.equity(.commonStock))

    static let revenue: AccountGroup = .incomeStatement(.revenue)
    static let cogs: AccountGroup = .incomeStatement(.expense(.cogs))
    static let depreciationExpenses: AccountGroup = .incomeStatement(.expense(.depreciation))

    static let rawInventory: AccountGroup = .balanceSheet(.asset(.currentAsset(.inventory(.rawMaterials))))
    static let wipsInventory: AccountGroup = .balanceSheet(.asset(.currentAsset(.inventory(.workInProgress))))
    static let finishedInventory: AccountGroup = .balanceSheet(.asset(.currentAsset(.inventory(.finishedGoods))))
}

