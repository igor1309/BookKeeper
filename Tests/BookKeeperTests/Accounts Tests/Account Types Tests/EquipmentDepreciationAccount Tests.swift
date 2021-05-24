import XCTest
// @testable
import BookKeeper

final class EquipmentDepreciationAccountTests: XCTestCase {
    func testEquipmentDepreciationAccountInit() {
        XCTAssertEqual(EquipmentDepreciationAccount.kind, .passive)

        XCTAssertEqual(EquipmentDepreciationAccount.accountGroup,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let equipmentDepreciationAccountZero: EquipmentDepreciationAccount = .init()
        XCTAssertEqual(equipmentDepreciationAccountZero.amount, 0)
        XCTAssertEqual(equipmentDepreciationAccountZero.balance(), 0)
        XCTAssertEqual(equipmentDepreciationAccountZero.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))

        let equipmentDepreciationAccountWithValue: EquipmentDepreciationAccount = .init(amount: 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.amount, 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.balance(), 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.group,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
    }

    func testDescription() {
        let equipmentDepreciationAccountZero: EquipmentDepreciationAccount = .init()
        XCTAssertEqual(equipmentDepreciationAccountZero.description,
                       "EquipmentDepreciationAccount(0.0)")

        let equipmentDepreciationAccountWithValue: EquipmentDepreciationAccount = .init(amount: 10_000)
        XCTAssertEqual(equipmentDepreciationAccountWithValue.description,
                       "EquipmentDepreciationAccount(10000.0)")
    }

}
