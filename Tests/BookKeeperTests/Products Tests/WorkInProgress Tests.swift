import XCTest
import BookKeeper

final class WorkInProgressTests: XCTestCase {

    func testWorkInProgressInit() {
        let wipNoInventory: WorkInProgress = .init(name: "WIP without Inventory")
        XCTAssertEqual(wipNoInventory.inventory.qty, 0)
        XCTAssertEqual(wipNoInventory.inventory.amount, 0)
        XCTAssert(wipNoInventory.inventory.balanceIsZero)

        let wipWithInventory: WorkInProgress = .sample
        XCTAssertEqual(wipWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(wipWithInventory.inventory.amount, 77_777)
        XCTAssertEqual(wipWithInventory.inventory.balance, 77_777)
    }

    func testDescription() {
        let wipNoInventory: WorkInProgress = .init(name: "WIP without Inventory")
        XCTAssertEqual(wipNoInventory.description,
                       "WorkInProgress WIP without Inventory(inventory: Inventory(qty: 0, amount: 0.0))")

        let wipWithInventory: WorkInProgress = .sample
        XCTAssertEqual(wipWithInventory.description,
                       "WorkInProgress WorkInProgress(inventory: Inventory(qty: 1000, amount: 77777.0))")
    }

}
