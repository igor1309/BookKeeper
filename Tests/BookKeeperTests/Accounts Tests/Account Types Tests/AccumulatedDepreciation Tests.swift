import XCTest
// @testable
import BookKeeper

final class AccumulatedDepreciationTests: XCTestCase {
    func testAccumulatedDepreciationInit() {
        XCTAssertEqual(AccumulatedDepreciation.kind, .passive)

        XCTAssertEqual(AccumulatedDepreciation.accountGroup,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationZero: AccumulatedDepreciation = .init()
        XCTAssertEqual(accumulatedDepreciationZero.amount, 0)
        XCTAssertEqual(accumulatedDepreciationZero.balance(), 0)
        XCTAssertEqual(accumulatedDepreciationZero.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationWithValue: AccumulatedDepreciation = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.amount, 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.balance(), 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testDescription() {
        let accumulatedDepreciationZero: AccumulatedDepreciation = .init()
        XCTAssertEqual(accumulatedDepreciationZero.description,
                       "AccumulatedDepreciation(0.0)")

        let accumulatedDepreciationWithValue: AccumulatedDepreciation = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.description,
                       "AccumulatedDepreciation(10000.0)")
    }

}
