import XCTest
import BookKeeper

// MARK: CaseIterable

extension AccountGroupTests {
    func testAccountGroupAllCases() {
        XCTAssertNotEqual(AccountGroup.allCases, [])
        XCTAssertFalse(AccountGroup.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.allCases.count, 29)

        XCTAssertFalse(AccountGroup.BalanceSheet.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.allCases.count, 23)

        XCTAssertFalse(AccountGroup.BalanceSheet.Asset.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Asset.allCases.count, 13)

        XCTAssertFalse(AccountGroup.BalanceSheet.Asset.CurrentAsset.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Asset.CurrentAsset.allCases.count, 6)

        XCTAssertFalse(AccountGroup.BalanceSheet.Asset.PropertyPlantEquipment.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Asset.PropertyPlantEquipment.allCases.count, 7)

        XCTAssertFalse(AccountGroup.BalanceSheet.Liability.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Liability.allCases.count, 7)

        XCTAssertFalse(AccountGroup.BalanceSheet.Liability.CurrentLiability.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Liability.CurrentLiability.allCases.count, 5)

        XCTAssertFalse(AccountGroup.BalanceSheet.Liability.LongtermLiability.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Liability.LongtermLiability.allCases.count, 2)

        XCTAssertFalse(AccountGroup.BalanceSheet.Equity.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.Equity.allCases.count, 3)

        XCTAssertFalse(AccountGroup.BalanceSheet.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.BalanceSheet.allCases.count, 23)

        XCTAssertFalse(AccountGroup.IncomeStatement.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.IncomeStatement.allCases.count, 6)
    }
}
