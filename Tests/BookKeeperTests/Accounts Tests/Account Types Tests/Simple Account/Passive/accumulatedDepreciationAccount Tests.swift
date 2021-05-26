import XCTest
// @testable
import BookKeeper

extension SimpleAccountTests {
    func testAccumulatedDepreciationAccount() {
        XCTAssertEqual(Account<AccumulatedDepreciation>.init().kind,
                       .passive)

        XCTAssertEqual(Account<AccumulatedDepreciation>.init().group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationZero: Account<AccumulatedDepreciation> = .init()
        XCTAssertEqual(accumulatedDepreciationZero.amount, 0)
        XCTAssertEqual(accumulatedDepreciationZero.balance(), 0)
        XCTAssertEqual(accumulatedDepreciationZero.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationWithValue: Account<AccumulatedDepreciation> = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.amount, 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.balance(), 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testAccumulatedDepreciationAccountDescription() {
        let accumulatedDepreciationZero: Account<AccumulatedDepreciation> = .init()
        XCTAssertEqual(accumulatedDepreciationZero.description,
                       "Accumulated Depreciation(Accumulated Depreciation Equipment (passive); 0.0)")

        let accumulatedDepreciationWithValue: Account<AccumulatedDepreciation> = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.description,
                       "Accumulated Depreciation(Accumulated Depreciation Equipment (passive); 10000.0)")
    }

}
