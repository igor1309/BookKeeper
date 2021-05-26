import XCTest
// @testable
import BookKeeper

extension AccountTests {
    func testEquipmentDepreciationAccount() {
        XCTAssertEqual(Account<EquipmentDepreciation>.init().kind,
                       .passive)

        XCTAssertEqual(Account<EquipmentDepreciation>.init().group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let equipmentDepreciationAccountZero: Account<EquipmentDepreciation> = .init()
        XCTAssertEqual(equipmentDepreciationAccountZero.amount, 0)
        XCTAssertEqual(equipmentDepreciationAccountZero.balance(), 0)
        XCTAssertEqual(equipmentDepreciationAccountZero.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let equipmentDepreciationAccountWithValue: Account<EquipmentDepreciation> = .init(amount: 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.amount, 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.balance(), 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testEquipmentDepreciationAccountDescription() {
        XCTFail("this doesn't look right")

        let equipmentDepreciationAccountZero: Account<EquipmentDepreciation> = .init()
        #warning("this doesn't look right")
        XCTAssertEqual(equipmentDepreciationAccountZero.description,
                       "Equipment Depreciation(Accumulated Depreciation Equipment (passive); 0.0)")

        let equipmentDepreciationAccountWithValue: Account<EquipmentDepreciation> = .init(amount: 10_000)
        #warning("this doesn't look right")
        XCTAssertEqual(equipmentDepreciationAccountWithValue.description,
                       "Equipment Depreciation(Accumulated Depreciation Equipment (passive); 10000.0)")
    }

}
