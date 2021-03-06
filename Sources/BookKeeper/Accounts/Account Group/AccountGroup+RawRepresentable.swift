extension AccountGroup {
    public static var all: [String] { ["Balance Sheet", "Income Statement"] }
}

extension BalanceSheet {
    public static var all: [String] { ["Asset", "Liability", "Equity"] }
}
extension IncomeStatement {
    public static var all: [String] { ["Revenue", "Expenses"] }
}

extension AccountGroup: RawRepresentable {
    public init?(rawValue: String) {
        if let balanceSheet = BalanceSheet(rawValue: rawValue) {
            self = .balanceSheet(balanceSheet)
        } else if let incomeStatement = IncomeStatement(rawValue: rawValue) {
            self = .incomeStatement(incomeStatement)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
            case .balanceSheet(let balanceSheet):
                return balanceSheet.rawValue
            case .incomeStatement(let incomeStatement):
                return incomeStatement.rawValue
        }
    }
}

extension BalanceSheet: RawRepresentable {
    public init?(rawValue: String) {
        if let asset = Asset(rawValue: rawValue) {
            self = .asset(asset)
        } else if let liability = Liability(rawValue: rawValue) {
            self = .liability(liability)
        } else if let equity = Equity(rawValue: rawValue) {
            self = .equity(equity)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
            case .asset(let asset):
                return asset.rawValue
            case .liability(let liability):
                return liability.rawValue
            case .equity(let equity):
                return equity.rawValue
        }
    }
}

extension BalanceSheet.Asset: RawRepresentable {
    public init?(rawValue: String) {
        if let currentAsset = CurrentAsset(rawValue: rawValue) {
            self = .currentAsset(currentAsset)
        } else if let propertyPlantEquipment = PropertyPlantEquipment(rawValue: rawValue) {
            self = .propertyPlantEquipment(propertyPlantEquipment)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
            case .currentAsset(let currentAsset):
                return currentAsset.rawValue
            case .propertyPlantEquipment(let propertyPlantEquipment):
                return propertyPlantEquipment.rawValue
        }
    }
}

extension BalanceSheet.Liability: RawRepresentable {
    public init?(rawValue: String) {
        if let currentLiability = CurrentLiability(rawValue: rawValue) {
            self = .currentLiability(currentLiability)
        } else if let longtermLiability = LongtermLiability(rawValue: rawValue) {
            self = .longtermLiability(longtermLiability)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
            case .currentLiability(let currentLiability):
                return currentLiability.rawValue
            case .longtermLiability(let longtermLiability):
                return longtermLiability.rawValue
        }
    }
}

extension IncomeStatement: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
            case "Revenue", "revenue":
                self = .revenue
            default:
                guard let expense = Expense(rawValue: rawValue) else {
                    return nil
                }
                self = .expense(expense)
        }
    }

    public var rawValue: String {
        switch self {
            case .revenue:
                return "Revenue"
            case .expense(let expense):
                return expense.rawValue
        }
    }

}
