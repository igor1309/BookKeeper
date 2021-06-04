import XCTest
import BookKeeper

extension AccountTests {
    func testDepreciationExpensesAccount() {
        XCTAssertEqual(Account.init(group: .depreciationExpenses).kind,
                       .active)

        XCTAssertEqual(Account.init(group: .depreciationExpenses).group,
                       .depreciationExpenses)

        let depreciationExpenses0: Account = .init(group: .depreciationExpenses)
        XCTAssert(depreciationExpenses0.balanceIsZero)
        XCTAssertEqual(depreciationExpenses0.group,
                       .depreciationExpenses)

        let depreciationExpenses1: Account = .init(group: .depreciationExpenses, amount: 1_000)
        XCTAssertEqual(depreciationExpenses1.balance, 1_000)
        XCTAssertEqual(depreciationExpenses1.group,
                       .depreciationExpenses)
    }

    func testDepreciationExpensesAccountDescription() {
        let depreciationExpensesZero: Account = .init(group: .depreciationExpenses)
        XCTAssertEqual(depreciationExpensesZero.description,
                       "Depreciation Expense, active: 0.0")

        let depreciationExpenses: Account = .init(group: .depreciationExpenses, amount: 10_000)
        XCTAssertEqual(depreciationExpenses.description,
                       "Depreciation Expense, active: 10000.0")
    }

}
