import XCTest
import BookKeeper

final class AccountTypeTests: XCTestCase {
    func testAccountsReceivable() {
        XCTAssertEqual(AccountsReceivable.defaultName, "Accounts Receivable")
        XCTAssertEqual(AccountsReceivable.kind, AccountKind.active)
        XCTAssertEqual(AccountsReceivable.group,
                       AccountGroup.balanceSheet(.asset(.currentAsset(.accountsReceivable))))
    }

    func testVATReceivable() {
        XCTAssertEqual(VATReceivable.defaultName, "VAT Receivable")
        XCTAssertEqual(VATReceivable.kind, AccountKind.active)
        XCTAssertEqual(VATReceivable.group,
                       AccountGroup.balanceSheet(.asset(.currentAsset(.vatReceivable))))
    }

    func testCash() {
        XCTAssertEqual(Cash.defaultName, "Cash")
        XCTAssertEqual(Cash.kind, AccountKind.active)
        XCTAssertEqual(Cash.group,
                       AccountGroup.balanceSheet(.asset(.currentAsset(.cash))))
    }

    func testCOGS() {
        XCTAssertEqual(COGS.defaultName, "COGS")
        XCTAssertEqual(COGS.kind, AccountKind.active)
        XCTAssertEqual(COGS.group,
                       AccountGroup.incomeStatement(.expense(.cogs)))
    }

    func testDepreciationExpenses() {
        XCTAssertEqual(DepreciationExpenses.defaultName, "Depreciation Expenses")
        XCTAssertEqual(DepreciationExpenses.kind, AccountKind.active)
        XCTAssertEqual(DepreciationExpenses.group,
                       AccountGroup.incomeStatement(.expense(.depreciation)))
    }

    func testAccountsPayable() {
        XCTAssertEqual(AccountsPayable.defaultName, "Accounts Payable")
        XCTAssertEqual(AccountsPayable.kind, AccountKind.passive)
        XCTAssertEqual(AccountsPayable.group,
                       AccountGroup.balanceSheet(.liability(.currentLiability(.accountsPayable))))
    }

    func testAccumulatedDepreciationEquipment() {
        XCTAssertEqual(AccumulatedDepreciationEquipment.defaultName, "Accumulated Depreciation Equipment")
        XCTAssertEqual(AccumulatedDepreciationEquipment.kind, AccountKind.passive)
        XCTAssertEqual(AccumulatedDepreciationEquipment.group,
                       AccountGroup.balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testTaxLiabilities() {
        XCTAssertEqual(TaxLiabilities.defaultName, "Tax Liabilities")
        XCTAssertEqual(TaxLiabilities.kind, AccountKind.passive)
        XCTAssertEqual(TaxLiabilities.group,
                       AccountGroup.balanceSheet(.liability(.currentLiability(.taxesPayable))))
    }

}
