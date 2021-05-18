/// The five major accounts provide the structure for your chart of accounts, breaking it down into separate categories of information. Several important financial reports are built around the same five categories. The five major accounts you’ll use to create your chart of accounts are:

///     `Assets`: Assets are resources owned by your business that can be converted into cash and therefore have monetary value. Examples of assets include your accounts receivable, vehicles, property and equipment.
///
///     `Liabilities`: Liabilities are debts that your company owes to someone else. This would include your accounts payable and any taxes you owe the government.
///
///     `Equity`: The role of equity differs in the chart of accounts based on whether your business is set up as a sole proprietorship, LLC or corporation. But the basic equation for determining equity is a company’s assets minus its debts.
///
///     `Revenue`: Revenue is the amount of money your business brings in by selling its products or services to clients.
///
///     `Expenses`: Expenses refer to the costs you incur in the process of running your business. This would include your office rent, utilities and office supplies.
///
/// Other listed at https://www.principlesofaccounting.com/account-types/

/// https://www.accountingcoach.com/chart-of-accounts/explanation
/// https://www.accountingcoach.com/chart-of-accounts/explanation/2
///
/// # Enums with associated values
///
/// The `benefit` - clear type definition using dot-syntax
///         .balanceSheet(.asset(.currentAsset(.cash)))
///
/// The `huge downside`
///
///     can't iterate over type values: can't conform to CaseIterable up until `leafs' like CurrentAsset, CurrentLiability, etc (CaseIterable enums without associated values)
///     if can't iterate then how to create, for example, an AccountGroupPicker, that should show the hierarchy
///
#warning("lots of code added - need to update tests")
public enum AccountGroup: Equatable, Hashable {
    case balanceSheet(BalanceSheet)
    case incomeStatement(IncomeStatement)
}

// MARK: - BalanceSheet

public enum BalanceSheet: Equatable, Hashable {
    case asset(Asset)
    case liability(Liability)
    case equity(Equity)

    public enum Asset: Equatable, Hashable {
        case currentAsset(CurrentAsset)
        case propertyPlantEquipment(PropertyPlantEquipment)

        public enum CurrentAsset: String, Equatable, Hashable, CaseIterable {
            case cash = "Cash"
            case accountsReceivable = "Accounts Receivable"
            case inventory = "Inventory"
        }

        public enum PropertyPlantEquipment: String, Equatable, Hashable, CaseIterable {
            case land = "Land"
            case buildings = "Buildings"
            case equipment = "Equipment"
            case vehicles = "Vehicles"
            case accumulatedDepreciationBuildings = "Accumulated Depreciation Buildings"
            case accumulatedDepreciationEquipment = "Accumulated Depreciation Equipment"
            case accumulatedDepreciationVehicles = "Accumulated Depreciation Vehicles"
        }
    }

    public enum Liability: Equatable, Hashable {
        case currentLiability(CurrentLiability)
        case longtermLiability(LongtermLiability)

        public enum CurrentLiability: String, Equatable, Hashable, CaseIterable {
            case notesPayable = "Notes Payable"
            case accountsPayable = "Accounts Payable"
            case wagesPayable = "Wages Payable"
            case interestPayable = "Interest Payable"
            case taxesPayable = "Taxes Payable"
        }

        public enum LongtermLiability: String, Equatable, Hashable, CaseIterable {
            case mortgageLoanPayable = "Mortgage Loan Payable"
            case bondsPayable = "Bonds Payable"
        }
    }

    public enum Equity: String, Equatable, Hashable, CaseIterable {
        case commonStock = "Common Stock"
        case retainedEarnings = "Retained Earnings"
        case treasuryStock = "Treasury Stock"
    }
}

// MARK: - IncomeStatement

public enum IncomeStatement: Equatable, Hashable {
    /// Operating Revenues (account numbers 30000 - 39999)
    /// 31010 Sales - Division #1, Product Line 010
    /// 31022 Sales - Division #1, Product Line 022
    /// 32015 Sales - Division #2, Product Line 015
    case revenue

    case expense(Expense)

    public enum Expense: String, Equatable, Hashable, CaseIterable {
        /*
         Cost of Goods Sold (account numbers 40000 - 49999)
         41010 COGS - Division #1, Product Line p
         41022 COGS - Division #1, Product Line 022
         42015 COGS - Division #2, Product Line 015
         43110 COGS - Division #3, Product Line 110
         */
        case cogs = "COGS"

        /*
         Marketing Expenses (account numbers 50000 - 50999)
         50100 Marketing Dept. Salaries
         50150 Marketing Dept. Payroll Taxes
         50200 Marketing Dept. Supplies
         50600 Marketing Dept. Telephone
         */
        case marketingExpenses = "Marketing Expenses"

        /*
         Payroll Dept. Expenses (account numbers 59000 - 59999)
         59100 Payroll Dept. Salaries
         59150 Payroll Dept. Payroll Taxes
         59200 Payroll Dept. Supplies
         59600 Payroll Dept. Telephone
         */
        case payroll = "Payroll"

        /*
         Other (account numbers 90000 - 99999)
         91800 Gain on Sale of Assets
         96100 Loss on Sale of Assets
         */
        case other = "Other"
    }
}
