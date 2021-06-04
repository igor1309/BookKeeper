import XCTest
@testable import BookKeeper

final class EquipmentTests: XCTestCase {
    func testEquipment() {
        let equipment: Equipment = .init(name: "Freezer",
                                         lifetime: 7,
                                         value: 7 * 12 * 9_999,
                                         vatRate: 20/100,
                                         depreciation: 200)

        XCTAssertEqual(equipment.name, "Freezer")
        XCTAssertEqual(equipment.initialValue, 7 * 12 * 9_999)
        XCTAssertEqual(equipment.lifetime, 7)
        XCTAssertEqual(equipment.depreciation, 200)
        XCTAssertEqual(equipment.carryingAmount, 7 * 12 * 9_999 - 200)
        XCTAssertEqual(equipment.depreciationAmountPerMonth, 9_999)
    }
}
