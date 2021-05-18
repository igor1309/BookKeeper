import XCTest
import BookKeeper

final class WorkInProgressTests: XCTestCase {

    func testWorkInProgressInit() {
        let wipNoInventory: WorkInProgress = .init()
        XCTAssertEqual(wipNoInventory.inventory.qty, 0)
        XCTAssertEqual(wipNoInventory.inventory.amount, 0)
        XCTAssertEqual(wipNoInventory.inventory.balance(), 0)

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let wipWithInventory: WorkInProgress = .init(inventory: inventory)
        XCTAssertEqual(wipWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(wipWithInventory.inventory.amount, 49_000)
        XCTAssertEqual(wipWithInventory.inventory.balance(), 49_000)
    }

    func testDescription() {
        let wipNoInventory: WorkInProgress = .init()
        XCTAssertEqual(wipNoInventory.description,
                       "WorkInProgress(inventory: Inventory(amount: 0.0, qty: 0))")

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let wipWithInventory: WorkInProgress = .init(inventory: inventory)
        XCTAssertEqual(wipWithInventory.description,
                       "WorkInProgress(inventory: Inventory(amount: 49000.0, qty: 1000))")
    }

}
