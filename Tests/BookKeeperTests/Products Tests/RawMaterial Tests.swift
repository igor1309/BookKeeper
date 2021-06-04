import XCTest
import BookKeeper

final class RawMaterialTests: XCTestCase {

    func testRawMaterialInit() {
        let rawMaterialNoInventory: RawMaterial = .init(name: "RawMaterial without Inventory")
        XCTAssertEqual(rawMaterialNoInventory.inventory.qty, 0)
        XCTAssertEqual(rawMaterialNoInventory.inventory.amount, 0)
        XCTAssert(rawMaterialNoInventory.inventory.balanceIsZero)

        let rawMaterialWithInventory: RawMaterial = .sample
        XCTAssertEqual(rawMaterialWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(rawMaterialWithInventory.inventory.amount, 35_000)
        XCTAssertEqual(rawMaterialWithInventory.inventory.balance, 35_000)
    }

    func testDescription() {
        let rawMaterialNoInventory: RawMaterial = .init(name: "RawMaterial without Inventory")
        XCTAssertEqual(rawMaterialNoInventory.description,
                       "RawMaterial RawMaterial without Inventory(inventory: Inventory(qty: 0, amount: 0.0))")

        let rawMaterialWithInventory: RawMaterial = .sample
        XCTAssertEqual(rawMaterialWithInventory.description,
                       "RawMaterial RawMaterial(inventory: Inventory(qty: 1000, amount: 35000.0))")
    }

}
