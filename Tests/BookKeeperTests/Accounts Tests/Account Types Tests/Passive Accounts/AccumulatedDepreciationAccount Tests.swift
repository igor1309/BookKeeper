import XCTest
// @testable
import BookKeeper

extension AccountTests {
    func testAccumulatedDepreciationEquipmentAccount() {
        XCTAssertEqual(Account.init(group: .accumulatedDepreciation).kind,
                       .passive)

        XCTAssertEqual(Account.init(group: .accumulatedDepreciation).group,
                       .accumulatedDepreciation)

        let accumulatedDepreciationZero: Account = .init(group: .accumulatedDepreciation)
        XCTAssert(accumulatedDepreciationZero.balanceIsZero)
        XCTAssertEqual(accumulatedDepreciationZero.group,
                       .accumulatedDepreciation)

        let accumulatedDepreciationWithValue: Account = .init(group: .accumulatedDepreciation, amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.balance, 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.group,
                       .accumulatedDepreciation)
    }

    func testAccumulatedDepreciationAccountDescription() {
        let accumulatedDepreciationZero: Account = .init(group: .accumulatedDepreciation)
        XCTAssertEqual(accumulatedDepreciationZero.description,
                       "Accumulated Depreciation Equipment, passive: 0.0")

        let accumulatedDepreciationWithValue: Account = .init(group: .accumulatedDepreciation, amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.description,
                       "Accumulated Depreciation Equipment, passive: 10000.0")
    }

}
