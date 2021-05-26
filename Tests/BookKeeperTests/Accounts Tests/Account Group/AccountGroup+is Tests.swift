import XCTest
import BookKeeper

extension AccountGroupTests {
    func testAccountGroupIsAsset() {
        XCTAssert(accountsReceivable.group.isAsset)
        XCTAssertFalse(cogsAccount.group.isAsset)
        XCTAssert(inventoryAccount.group.isAsset)
        XCTAssertFalse(revenueAccount.group.isAsset)
        XCTAssertFalse(taxLiabilities.group.isAsset)
    }

    func testAccountGroupIsCurrentAsset() {
        XCTAssert(accountsReceivable.group.isCurrentAsset)
        XCTAssertFalse(cogsAccount.group.isCurrentAsset)
        XCTAssert(inventoryAccount.group.isCurrentAsset)
        XCTAssertFalse(revenueAccount.group.isCurrentAsset)
        XCTAssertFalse(taxLiabilities.group.isCurrentAsset)
    }

    func testAccountGroupIsPropertyPlantEquipment() {
        XCTAssertFalse(accountsReceivable.group.isPropertyPlantEquipment)
        XCTAssertFalse(cogsAccount.group.isPropertyPlantEquipment)
        XCTAssertFalse(inventoryAccount.group.isPropertyPlantEquipment)
        XCTAssertFalse(revenueAccount.group.isPropertyPlantEquipment)
        XCTAssertFalse(taxLiabilities.group.isPropertyPlantEquipment)
    }

    func testAccountGroupIsLiability() {
        XCTAssertFalse(accountsReceivable.group.isLiability)
        XCTAssertFalse(cogsAccount.group.isLiability)
        XCTAssertFalse(inventoryAccount.group.isLiability)
        XCTAssertFalse(revenueAccount.group.isLiability)
        XCTAssert(taxLiabilities.group.isLiability)
    }

    func testAccountGroupIsCurrentLiability() {
        XCTAssertFalse(accountsReceivable.group.isCurrentLiability)
        XCTAssertFalse(cogsAccount.group.isCurrentLiability)
        XCTAssertFalse(inventoryAccount.group.isCurrentLiability)
        XCTAssertFalse(revenueAccount.group.isCurrentLiability)
        XCTAssert(taxLiabilities.group.isCurrentLiability)
    }

    func testAccountGroupIsLongtermLiability() {
        XCTAssertFalse(accountsReceivable.group.isLongtermLiability)
        XCTAssertFalse(cogsAccount.group.isLongtermLiability)
        XCTAssertFalse(inventoryAccount.group.isLongtermLiability)
        XCTAssertFalse(revenueAccount.group.isLongtermLiability)
        XCTAssertFalse(taxLiabilities.group.isLongtermLiability)
    }

    func testAccountGroupIsEquity() {
        XCTAssertFalse(accountsReceivable.group.isEquity)
        XCTAssertFalse(cogsAccount.group.isEquity)
        XCTAssertFalse(inventoryAccount.group.isEquity)
        XCTAssertFalse(revenueAccount.group.isEquity)
        XCTAssertFalse(taxLiabilities.group.isEquity)

    }

    func testAccountGroupIsRevenue() {
        XCTAssertFalse(accountsReceivable.group.isRevenue)
        XCTAssertFalse(cogsAccount.group.isRevenue)
        XCTAssertFalse(inventoryAccount.group.isRevenue)
        XCTAssert(revenueAccount.group.isRevenue)
        XCTAssertFalse(taxLiabilities.group.isRevenue)
    }

    func testAccountGroupIsExpense() {
        XCTAssertFalse(accountsReceivable.group.isExpense)
        XCTAssert(cogsAccount.group.isExpense)
        XCTAssertFalse(inventoryAccount.group.isExpense)
        XCTAssertFalse(revenueAccount.group.isExpense)
        XCTAssertFalse(taxLiabilities.group.isExpense)
    }

}
