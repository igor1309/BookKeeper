import XCTest
import BookKeeper

final class RawMaterialTests: XCTestCase {

    func testRawMaterialInit() {
        let rawMaterialNoInventory: RawMaterial = .init()
        XCTAssertEqual(rawMaterialNoInventory.inventory.qty, 0)
        XCTAssertEqual(rawMaterialNoInventory.inventory.amount, 0)
        XCTAssert(rawMaterialNoInventory.inventory.balanceIsZero)

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let rawMaterialWithInventory: RawMaterial = .init(inventory: inventory)
        XCTAssertEqual(rawMaterialWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(rawMaterialWithInventory.inventory.amount, 49_000)
        XCTAssertEqual(rawMaterialWithInventory.inventory.balance, 49_000)
    }

    func testDescription() {
        let rawMaterialNoInventory: RawMaterial = .init()
        XCTAssertEqual(rawMaterialNoInventory.description,
                       "RawMaterial(inventory: Inventory(qty: 0, amount: 0.0))")

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let rawMaterialWithInventory: RawMaterial = .init(inventory: inventory)
        XCTAssertEqual(rawMaterialWithInventory.description,
                       "RawMaterial(inventory: Inventory(qty: 1000, amount: 49000.0))")
    }

}
