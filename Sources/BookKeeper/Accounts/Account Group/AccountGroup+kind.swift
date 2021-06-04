extension AccountGroup {
    var kind: AccountKind {
        switch self {
            case let .balanceSheet(balanceSheet):       return balanceSheet.kind
            case let .incomeStatement(incomeStatement): return incomeStatement.kind
        }
    }
}

extension AccountGroup.BalanceSheet {
    var kind: AccountKind {
        switch self {
            case let .asset(asset): return asset.kind
            case .liability:        return .passive
            case .equity:           return .passive
        }
    }
}

extension AccountGroup.BalanceSheet.Asset {
    var kind: AccountKind {
        switch self {
            case .currentAsset:
                return .active
            case let .propertyPlantEquipment(propertyPlantEquipment):
                return propertyPlantEquipment.kind
        }
    }
}

extension AccountGroup.BalanceSheet.Asset.PropertyPlantEquipment {
    var kind: AccountKind {
        switch self {
            case .land,
                 .buildings,
                 .equipment,
                 .vehicles:
                return .active

            case .accumulatedDepreciationBuildings,
                 .accumulatedDepreciationEquipment,
                 .accumulatedDepreciationVehicles:
                return .passive
        }
    }
}

extension AccountGroup.IncomeStatement {
    var kind: AccountKind {
        switch self {
            case .revenue: return .passive
            case .expense: return .active
        }
    }
}
