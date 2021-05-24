import XCTest
import BookKeeper

final class DepreciationExpensesTests: XCTestCase {
    func testDepreciationExpensesInit() {
        XCTAssertEqual(DepreciationExpenses.kind, .active)

        XCTAssertEqual(DepreciationExpenses.accountGroup,
                       .incomeStatement(.expense(.depreciation)))

        let depreciationExpenses0: DepreciationExpenses = .init()
        XCTAssertEqual(depreciationExpenses0.amount, 0)
        XCTAssertEqual(depreciationExpenses0.balance(), 0)
        XCTAssertEqual(depreciationExpenses0.group,
                       .incomeStatement(.expense(.depreciation)))

        let depreciationExpenses1: DepreciationExpenses = .init(amount: 1_000)
        XCTAssertEqual(depreciationExpenses1.amount, 1_000)
        XCTAssertEqual(depreciationExpenses1.balance(), 1_000)
        XCTAssertEqual(depreciationExpenses1.group,
                       .incomeStatement(.expense(.depreciation)))
    }

    func testDescription() {
        XCTAssertEqual(DepreciationExpenses().description,
                       "DepreciationExpenses(0.0)")
        XCTAssertEqual(DepreciationExpenses(amount: 10_000).description,
                       "DepreciationExpenses(10000.0)")
    }

}

