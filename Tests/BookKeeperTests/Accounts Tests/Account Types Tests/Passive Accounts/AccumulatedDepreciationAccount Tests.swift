import XCTest
// @testable
import BookKeeper

extension AccountTests {
    func testAccumulatedDepreciationEquipmentAccount() {
        XCTAssertEqual(Account<AccumulatedDepreciationEquipment>.init().kind,
                       .passive)

        XCTAssertEqual(Account<AccumulatedDepreciationEquipment>.init().group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationZero: Account<AccumulatedDepreciationEquipment> = .init()
        XCTAssertEqual(accumulatedDepreciationZero.balance(), 0)
        XCTAssertEqual(accumulatedDepreciationZero.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let accumulatedDepreciationWithValue: Account<AccumulatedDepreciationEquipment> = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.balance(), 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testAccumulatedDepreciationAccountDescription() {
        let accumulatedDepreciationZero: Account<AccumulatedDepreciationEquipment> = .init()
        XCTAssertEqual(accumulatedDepreciationZero.description,
                       "Accumulated Depreciation Equipment(Accumulated Depreciation Equipment (passive); 0.0)")

        let accumulatedDepreciationWithValue: Account<AccumulatedDepreciationEquipment> = .init(amount: 10_000)
        XCTAssertEqual(accumulatedDepreciationWithValue.description,
                       "Accumulated Depreciation Equipment(Accumulated Depreciation Equipment (passive); 10000.0)")
    }

}
