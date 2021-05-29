extension AccountGroup {
    public var isAsset: Bool {
        switch self {
            case .balanceSheet(.asset):
                return true
            default:
                return false
        }
    }

    public var isCurrentAsset: Bool {
        switch self {
            case .balanceSheet(.asset(.currentAsset)):
                return true
            default:
                return false
        }
    }

    public var isPropertyPlantEquipment: Bool {
        switch self {
            case .balanceSheet(.asset(.propertyPlantEquipment)):
                return true
            default:
                return false
        }
    }

    public var isLiability: Bool {
        switch self {
            case .balanceSheet(.liability):
                return true
            default:
                return false
        }
    }

    public var isCurrentLiability: Bool {
        switch self {
            case .balanceSheet(.liability(.currentLiability)):
                return true
            default:
                return false
        }
    }

    public var isLongtermLiability: Bool {
        switch self {
            case .balanceSheet(.liability(.longtermLiability)):
                return true
            default:
                return false
        }
    }

    public var isEquity: Bool {
        switch self {
            case .balanceSheet(.equity):
                return true
            default:
                return false
        }
    }

    public var isRevenue: Bool {
        switch self {
            case .incomeStatement(.revenue):
                return true
            default:
                return false
        }
    }

    public var isExpense: Bool {
        switch self {
            case .incomeStatement(.expense):
                return true
            default:
                return false
        }
    }

}
