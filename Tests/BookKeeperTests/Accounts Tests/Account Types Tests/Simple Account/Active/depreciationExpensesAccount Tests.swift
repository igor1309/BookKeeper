import XCTest
import BookKeeper

extension SimpleAccountTests {
    func testDepreciationExpensesAccount() {
        XCTAssertEqual(Account<DepreciationExpenses>.init().kind,
                       .active)

        XCTAssertEqual(Account<DepreciationExpenses>.init().group,
                       .incomeStatement(.expense(.depreciation)))

        let depreciationExpenses0: Account<DepreciationExpenses> = .init()
        XCTAssertEqual(depreciationExpenses0.amount, 0)
        XCTAssertEqual(depreciationExpenses0.balance(), 0)
        XCTAssertEqual(depreciationExpenses0.group,
                       .incomeStatement(.expense(.depreciation)))

        let depreciationExpenses1: Account<DepreciationExpenses> = .init(amount: 1_000)
        XCTAssertEqual(depreciationExpenses1.amount, 1_000)
        XCTAssertEqual(depreciationExpenses1.balance(), 1_000)
        XCTAssertEqual(depreciationExpenses1.group,
                       .incomeStatement(.expense(.depreciation)))
    }

    func testDepreciationExpensesAccountDescription() {
        let depreciationExpensesZero: Account<DepreciationExpenses> = .init()
        XCTAssertEqual(depreciationExpensesZero.description,
                       "Depreciation Expenses(Depreciation Expense (active); 0.0)")

        let depreciationExpenses: Account<DepreciationExpenses> = .init(amount: 10_000)
        XCTAssertEqual(depreciationExpenses.description,
                       "Depreciation Expenses(Depreciation Expense (active); 10000.0)")
    }

}

