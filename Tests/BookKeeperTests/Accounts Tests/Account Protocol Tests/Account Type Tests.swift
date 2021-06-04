import XCTest
import BookKeeper

final class AccountTypeTests: XCTestCase {
    func testAccountsReceivable() {
        XCTAssertEqual(AccountsReceivable.defaultName, "Accounts Receivable")
        XCTAssertEqual(AccountsReceivable.kind, .active)
        XCTAssertEqual(AccountsReceivable.group, .receivables)
    }

    func testVATReceivable() {
        XCTAssertEqual(VATReceivable.defaultName, "VAT Receivable")
        XCTAssertEqual(VATReceivable.kind, .active)
        XCTAssertEqual(VATReceivable.group, .vatReceivable)
    }

    func testCash() {
        XCTAssertEqual(Cash.defaultName, "Cash")
        XCTAssertEqual(Cash.kind, .active)
        XCTAssertEqual(Cash.group, .cash)
    }

    func testCOGS() {
        XCTAssertEqual(COGS.defaultName, "COGS")
        XCTAssertEqual(COGS.kind, .active)
        XCTAssertEqual(COGS.group, .cogs)
    }

    func testDepreciationExpenses() {
        XCTAssertEqual(DepreciationExpenses.defaultName, "Depreciation Expenses")
        XCTAssertEqual(DepreciationExpenses.kind, .active)
        XCTAssertEqual(DepreciationExpenses.group, .depreciationExpenses)
    }

    func testAccountsPayable() {
        XCTAssertEqual(AccountsPayable.defaultName, "Accounts Payable")
        XCTAssertEqual(AccountsPayable.kind, .passive)
        XCTAssertEqual(AccountsPayable.group, .payables)
    }

    func testAccumulatedDepreciationEquipment() {
        XCTAssertEqual(AccumulatedDepreciationEquipment.defaultName, "Accumulated Depreciation Equipment")
        XCTAssertEqual(AccumulatedDepreciationEquipment.kind, .passive)
        XCTAssertEqual(AccumulatedDepreciationEquipment.group,
                       .accumulatedDepreciation)
    }

    func testTaxLiabilities() {
        XCTAssertEqual(TaxLiabilities.defaultName, "Tax Liabilities")
        XCTAssertEqual(TaxLiabilities.kind, .passive)
        XCTAssertEqual(TaxLiabilities.group, .taxesPayable)
    }

}
