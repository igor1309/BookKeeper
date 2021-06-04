import XCTest
import BookKeeper

extension AccountGroupTests {
    func testVarAll() {
        XCTAssertEqual(AccountGroup.all,
                       ["Balance Sheet", "Income Statement"])

        XCTAssertEqual(AccountGroup.BalanceSheet.all,
                       ["Asset", "Liability", "Equity"])

        XCTAssertEqual(AccountGroup.IncomeStatement.all,
                       ["Revenue", "Expenses"])
    }

    func testAccountGroupRawRepresentable() {
        XCTAssertNil(AccountGroup(rawValue: "Cash Equivalent"))

        XCTAssertEqual(AccountGroup(rawValue: "Cash"),
                       .cash)
        XCTAssertEqual(AccountGroup(rawValue: "Marketing Expense"),
                       AccountGroup.incomeStatement(.expense(.marketingExpenses)))
    }

    func testAccountGroupRawValue() {
        XCTAssertEqual(AccountGroup.cash.rawValue,
                       "Cash")
        XCTAssertEqual(AccountGroup.cogs.rawValue,
                       "COGS")
    }

    func testBalanceSheetRawRepresentable() {
        XCTAssertNil(AccountGroup.BalanceSheet(rawValue: "Cash Equivalent"))

        XCTAssertEqual(AccountGroup.BalanceSheet(rawValue: "Accounts Receivable"),
                       AccountGroup.BalanceSheet.asset(.currentAsset(.accountsReceivable)))

        XCTAssertEqual(AccountGroup.BalanceSheet(rawValue: "Accounts Payable"),
                       AccountGroup.BalanceSheet.liability(.currentLiability(.accountsPayable)))

        XCTAssertEqual(AccountGroup.BalanceSheet(rawValue: "Common Stock"),
                       AccountGroup.BalanceSheet.equity(.commonStock))
    }

    func testBalanceSheetRawValue() {
        XCTAssertEqual(AccountGroup.BalanceSheet.asset(.currentAsset(.accountsReceivable)).rawValue,
                       "Accounts Receivable")

        XCTAssertEqual(AccountGroup.BalanceSheet.liability(.currentLiability(.accountsPayable)).rawValue,
                       "Accounts Payable")

        XCTAssertEqual(AccountGroup.BalanceSheet.equity(.commonStock).rawValue,
                       "Common Stock")

    }

    func testAssetRawRepresentable() {
        XCTAssertNil(AccountGroup.BalanceSheet.Asset(rawValue: "Cash Equivalent"))

        XCTAssertEqual(AccountGroup.BalanceSheet.Asset(rawValue: "VAT Receivable"),
                       AccountGroup.BalanceSheet.Asset.currentAsset(.vatReceivable))

        XCTAssertEqual(AccountGroup.BalanceSheet.Asset(rawValue: "Equipment"),
                       AccountGroup.BalanceSheet.Asset.propertyPlantEquipment(.equipment))
    }

    func testAssetRawValue() {
        XCTAssertEqual(AccountGroup.BalanceSheet.Asset.currentAsset(.vatReceivable).rawValue,
                       "VAT Receivable")

        XCTAssertEqual(AccountGroup.BalanceSheet.Asset.propertyPlantEquipment(.equipment).rawValue,
                       "Equipment")

    }

    func testLiabilityRawRepresentable() {
        XCTAssertNil(AccountGroup.BalanceSheet.Liability(rawValue: "Cash Equivalent"))

        XCTAssertEqual(AccountGroup.BalanceSheet.Liability(rawValue: "Notes Payable"),
                       AccountGroup.BalanceSheet.Liability.currentLiability(.notesPayable))

        XCTAssertEqual(AccountGroup.BalanceSheet.Liability(rawValue: "Bonds Payable"),
                       AccountGroup.BalanceSheet.Liability.longtermLiability(.bondsPayable))
    }

    func testLiabilityRawValue() {
        XCTAssertEqual(AccountGroup.BalanceSheet.Liability.currentLiability(.notesPayable).rawValue,
                       "Notes Payable")

        XCTAssertEqual(AccountGroup.BalanceSheet.Liability.longtermLiability(.bondsPayable).rawValue,
                       "Bonds Payable")

    }

    func testIncomeStatementRawRepresentable() {
        XCTAssertNil(AccountGroup.IncomeStatement(rawValue: "Cash Equivalent"))

        XCTAssertEqual(AccountGroup.IncomeStatement(rawValue: "Revenue"),
                       AccountGroup.IncomeStatement.revenue)

        XCTAssertEqual(AccountGroup.IncomeStatement(rawValue: "COGS"),
                       AccountGroup.IncomeStatement.expense(.cogs))
    }

    func testIncomeStatementRawValue() {
        XCTAssertEqual(AccountGroup.IncomeStatement.revenue.rawValue,
                       "Revenue")

        XCTAssertEqual(AccountGroup.IncomeStatement.expense(.cogs).rawValue,
                       "COGS")
    }

}
