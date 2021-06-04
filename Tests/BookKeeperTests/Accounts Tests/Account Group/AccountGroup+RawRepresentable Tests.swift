import XCTest
import BookKeeper

extension AccountGroupTests {
    func testVarAll() {
        XCTAssertEqual(AccountGroup.all,
                       ["Balance Sheet", "Income Statement"])

        XCTAssertEqual(BalanceSheet.all,
                       ["Asset", "Liability", "Equity"])

        XCTAssertEqual(IncomeStatement.all,
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
        XCTAssertNil(BalanceSheet(rawValue: "Cash Equivalent"))

        XCTAssertEqual(BalanceSheet(rawValue: "Accounts Receivable"),
                       BalanceSheet.asset(.currentAsset(.accountsReceivable)))

        XCTAssertEqual(BalanceSheet(rawValue: "Accounts Payable"),
                       BalanceSheet.liability(.currentLiability(.accountsPayable)))

        XCTAssertEqual(BalanceSheet(rawValue: "Common Stock"),
                       BalanceSheet.equity(.commonStock))
    }

    func testBalanceSheetRawValue() {
        XCTAssertEqual(BalanceSheet.asset(.currentAsset(.accountsReceivable)).rawValue,
                       "Accounts Receivable")

        XCTAssertEqual(BalanceSheet.liability(.currentLiability(.accountsPayable)).rawValue,
                       "Accounts Payable")

        XCTAssertEqual(BalanceSheet.equity(.commonStock).rawValue,
                       "Common Stock")

    }

    func testAssetRawRepresentable() {
        XCTAssertNil(BalanceSheet.Asset(rawValue: "Cash Equivalent"))

        XCTAssertEqual(BalanceSheet.Asset(rawValue: "VAT Receivable"),
                       BalanceSheet.Asset.currentAsset(.vatReceivable))

        XCTAssertEqual(BalanceSheet.Asset(rawValue: "Equipment"),
                       BalanceSheet.Asset.propertyPlantEquipment(.equipment))
    }

    func testAssetRawValue() {
        XCTAssertEqual(BalanceSheet.Asset.currentAsset(.vatReceivable).rawValue,
                       "VAT Receivable")

        XCTAssertEqual(BalanceSheet.Asset.propertyPlantEquipment(.equipment).rawValue,
                       "Equipment")

    }

    func testLiabilityRawRepresentable() {
        XCTAssertNil(BalanceSheet.Liability(rawValue: "Cash Equivalent"))

        XCTAssertEqual(BalanceSheet.Liability(rawValue: "Notes Payable"),
                       BalanceSheet.Liability.currentLiability(.notesPayable))

        XCTAssertEqual(BalanceSheet.Liability(rawValue: "Bonds Payable"),
                       BalanceSheet.Liability.longtermLiability(.bondsPayable))
    }

    func testLiabilityRawValue() {
        XCTAssertEqual(BalanceSheet.Liability.currentLiability(.notesPayable).rawValue,
                       "Notes Payable")

        XCTAssertEqual(BalanceSheet.Liability.longtermLiability(.bondsPayable).rawValue,
                       "Bonds Payable")

    }

    func testIncomeStatementRawRepresentable() {
        XCTAssertNil(IncomeStatement(rawValue: "Cash Equivalent"))

        XCTAssertEqual(IncomeStatement(rawValue: "Revenue"),
                       IncomeStatement.revenue)

        XCTAssertEqual(IncomeStatement(rawValue: "COGS"),
                       IncomeStatement.expense(.cogs))
    }

    func testIncomeStatementRawValue() {
        XCTAssertEqual(IncomeStatement.revenue.rawValue,
                       "Revenue")

        XCTAssertEqual(IncomeStatement.expense(.cogs).rawValue,
                       "COGS")
    }

}
