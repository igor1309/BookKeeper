import XCTest
import BookKeeper

extension AccountGroupTests {
    func testAccountGroupIsAsset() {
        XCTAssert(inventoryAccount.group.isAsset)
        XCTAssert(accountsReceivable.group.isAsset)
        XCTAssert(vatReceivable.group.isAsset)
        XCTAssert(cash.group.isAsset)
        XCTAssertFalse(cogsAccount.group.isAsset)
        XCTAssertFalse(depreciationExpenses.group.isAsset)
        XCTAssertFalse(accountsPayable.group.isAsset)
        XCTAssert(accumulatedDepreciationEquipment.group.isAsset)
        XCTAssertFalse(taxLiabilities.group.isAsset)
        XCTAssertFalse(revenueAccount.group.isAsset)
    }

    func testAccountGroupIsCurrentAsset() {
        XCTAssert(inventoryAccount.group.isCurrentAsset)
        XCTAssert(accountsReceivable.group.isCurrentAsset)
        XCTAssert(vatReceivable.group.isCurrentAsset)
        XCTAssert(cash.group.isCurrentAsset)
        XCTAssertFalse(cogsAccount.group.isCurrentAsset)
        XCTAssertFalse(depreciationExpenses.group.isCurrentAsset)
        XCTAssertFalse(accountsPayable.group.isCurrentAsset)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isCurrentAsset)
        XCTAssertFalse(taxLiabilities.group.isCurrentAsset)
        XCTAssertFalse(revenueAccount.group.isCurrentAsset)
    }

    func testAccountGroupIsPropertyPlantEquipment() {
        XCTAssertFalse(inventoryAccount.group.isPropertyPlantEquipment)
        XCTAssertFalse(accountsReceivable.group.isPropertyPlantEquipment)
        XCTAssertFalse(vatReceivable.group.isPropertyPlantEquipment)
        XCTAssertFalse(cash.group.isPropertyPlantEquipment)
        XCTAssertFalse(cogsAccount.group.isPropertyPlantEquipment)
        XCTAssertFalse(depreciationExpenses.group.isPropertyPlantEquipment)
        XCTAssertFalse(accountsPayable.group.isPropertyPlantEquipment)
        XCTAssert(accumulatedDepreciationEquipment.group.isPropertyPlantEquipment)
        XCTAssertFalse(taxLiabilities.group.isPropertyPlantEquipment)
        XCTAssertFalse(revenueAccount.group.isPropertyPlantEquipment)
    }

    func testAccountGroupIsLiability() {
        XCTAssertFalse(inventoryAccount.group.isLiability)
        XCTAssertFalse(accountsReceivable.group.isLiability)
        XCTAssertFalse(vatReceivable.group.isLiability)
        XCTAssertFalse(cash.group.isLiability)
        XCTAssertFalse(cogsAccount.group.isLiability)
        XCTAssertFalse(depreciationExpenses.group.isLiability)
        XCTAssert(accountsPayable.group.isLiability)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isLiability)
        XCTAssert(taxLiabilities.group.isLiability)
        XCTAssertFalse(revenueAccount.group.isLiability)
    }

    func testAccountGroupIsCurrentLiability() {
        XCTAssertFalse(inventoryAccount.group.isCurrentLiability)
        XCTAssertFalse(accountsReceivable.group.isCurrentLiability)
        XCTAssertFalse(vatReceivable.group.isCurrentLiability)
        XCTAssertFalse(cash.group.isCurrentLiability)
        XCTAssertFalse(cogsAccount.group.isCurrentLiability)
        XCTAssertFalse(depreciationExpenses.group.isCurrentLiability)
        XCTAssert(accountsPayable.group.isCurrentLiability)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isCurrentLiability)
        XCTAssert(taxLiabilities.group.isCurrentLiability)
        XCTAssertFalse(revenueAccount.group.isCurrentLiability)
    }

    func testAccountGroupIsLongtermLiability() {
        XCTAssertFalse(inventoryAccount.group.isLongtermLiability)
        XCTAssertFalse(accountsReceivable.group.isLongtermLiability)
        XCTAssertFalse(vatReceivable.group.isLongtermLiability)
        XCTAssertFalse(cash.group.isLongtermLiability)
        XCTAssertFalse(cogsAccount.group.isLongtermLiability)
        XCTAssertFalse(depreciationExpenses.group.isLongtermLiability)
        XCTAssertFalse(accountsPayable.group.isLongtermLiability)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isLongtermLiability)
        XCTAssertFalse(taxLiabilities.group.isLongtermLiability)
        XCTAssertFalse(revenueAccount.group.isLongtermLiability)
    }

    func testAccountGroupIsEquity() {
        XCTAssertFalse(inventoryAccount.group.isEquity)
        XCTAssertFalse(accountsReceivable.group.isEquity)
        XCTAssertFalse(vatReceivable.group.isEquity)
        XCTAssertFalse(cash.group.isEquity)
        XCTAssertFalse(cogsAccount.group.isEquity)
        XCTAssertFalse(depreciationExpenses.group.isEquity)
        XCTAssertFalse(accountsPayable.group.isEquity)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isEquity)
        XCTAssertFalse(taxLiabilities.group.isEquity)
        XCTAssertFalse(revenueAccount.group.isEquity)
    }

    func testAccountGroupIsRevenue() {
        XCTAssertFalse(inventoryAccount.group.isRevenue)
        XCTAssertFalse(accountsReceivable.group.isRevenue)
        XCTAssertFalse(vatReceivable.group.isRevenue)
        XCTAssertFalse(cash.group.isRevenue)
        XCTAssertFalse(cogsAccount.group.isRevenue)
        XCTAssertFalse(depreciationExpenses.group.isRevenue)
        XCTAssertFalse(accountsPayable.group.isRevenue)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isRevenue)
        XCTAssertFalse(taxLiabilities.group.isRevenue)
        XCTAssert(revenueAccount.group.isRevenue)
    }

    func testAccountGroupIsExpense() {
        XCTAssertFalse(inventoryAccount.group.isExpense)
        XCTAssertFalse(accountsReceivable.group.isExpense)
        XCTAssertFalse(vatReceivable.group.isExpense)
        XCTAssertFalse(cash.group.isExpense)
        XCTAssert(cogsAccount.group.isExpense)
        XCTAssert(depreciationExpenses.group.isExpense)
        XCTAssertFalse(accountsPayable.group.isExpense)
        XCTAssertFalse(accumulatedDepreciationEquipment.group.isExpense)
        XCTAssertFalse(taxLiabilities.group.isExpense)
        XCTAssertFalse(revenueAccount.group.isExpense)
    }

}
