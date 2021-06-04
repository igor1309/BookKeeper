import XCTest
import BookKeeper

// CaseIterable
extension AccountGroupTests {
    func testAccountGroupAllCases() {
        XCTAssertNotEqual(AccountGroup.allCases, [])
        XCTAssertFalse(AccountGroup.allCases.isEmpty)
        XCTAssertEqual(AccountGroup.allCases.count, 29)

        XCTAssertFalse(BalanceSheet.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.allCases.count, 23)

        XCTAssertFalse(BalanceSheet.Asset.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Asset.allCases.count, 13)

        XCTAssertFalse(BalanceSheet.Asset.CurrentAsset.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Asset.CurrentAsset.allCases.count, 6)

        XCTAssertFalse(BalanceSheet.Asset.PropertyPlantEquipment.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Asset.PropertyPlantEquipment.allCases.count, 7)

        XCTAssertFalse(BalanceSheet.Liability.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Liability.allCases.count, 7)

        XCTAssertFalse(BalanceSheet.Liability.CurrentLiability.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Liability.CurrentLiability.allCases.count, 5)

        XCTAssertFalse(BalanceSheet.Liability.LongtermLiability.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Liability.LongtermLiability.allCases.count, 2)

        XCTAssertFalse(BalanceSheet.Equity.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.Equity.allCases.count, 3)

        XCTAssertFalse(BalanceSheet.allCases.isEmpty)
        XCTAssertEqual(BalanceSheet.allCases.count, 23)

        XCTAssertFalse(IncomeStatement.allCases.isEmpty)
        XCTAssertEqual(IncomeStatement.allCases.count, 6)
    }
}
