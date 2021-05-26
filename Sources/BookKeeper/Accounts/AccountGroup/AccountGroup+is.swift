extension AccountGroup {
    public var isAsset: Bool {
        switch self {
            case .balanceSheet(.asset(_)):
                return true
            default:
                return false
        }
    }

    public var isCurrentAsset: Bool {
        switch self {
            case .balanceSheet(.asset(.currentAsset(_))):
                return true
            default:
                return false
        }
    }

    public var isPropertyPlantEquipment: Bool {
        switch self {
            case .balanceSheet(.asset(.propertyPlantEquipment(_))):
                return true
            default:
                return false
        }
    }

    public var isLiability: Bool {
        switch self {
            case .balanceSheet(.liability(_)):
                return true
            default:
                return false
        }
    }

    public var isCurrentLiability: Bool {
        switch self {
            case .balanceSheet(.liability(.currentLiability(_))):
                return true
            default:
                return false
        }
    }

    public var isLongtermLiability: Bool {
        switch self {
            case .balanceSheet(.liability(.longtermLiability(_))):
                return true
            default:
                return false
        }
    }

    public var isEquity: Bool {
        switch self {
            case .balanceSheet(.equity(_)):
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
            case .incomeStatement(.expense(_)):
                return true
            default:
                return false
        }
    }

}
