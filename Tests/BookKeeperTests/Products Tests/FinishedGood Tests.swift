import XCTest
import BookKeeper

final class FinishedGoodTests: XCTestCase {

    func testFinishedGoodInit() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertEqual(finishedNoInventory.inventory.qty, 0)
        XCTAssertEqual(finishedNoInventory.inventory.amount, 0)
        XCTAssert(finishedNoInventory.inventory.balanceIsZero)
        XCTAssert(finishedNoInventory.cogs.balanceIsZero)

        let finishedWithInventory: FinishedGood = .sample
        XCTAssertEqual(finishedWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(finishedWithInventory.inventory.amount, 49_000)
        XCTAssertEqual(finishedWithInventory.inventory.balance, 49_000)
        XCTAssertEqual(finishedWithInventory.cogs.balance, 35_000)
    }

    func testCost() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertNil(finishedNoInventory.cost())

        let finishedWithInventory: FinishedGood = .sample
        XCTAssertEqual(finishedWithInventory.cost(), 49.0)
    }

    func testDescription() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertEqual(finishedNoInventory.description,
                       """
                       FinishedGood 'Finished good without Inventory'
                       \tInventory: Inventory(qty: 0, amount: 0.0)
                       \tCOGS: COGS, active: 0.0)
                       """)

        let finishedWithInventory: FinishedGood = .sample
        XCTAssertEqual(finishedWithInventory.description,
                       """
                       FinishedGood 'Finished Good with Inventory'
                       \tInventory: Inventory(qty: 1000, amount: 49000.0)
                       \tCOGS: COGS, active: 35000.0)
                       """)
    }

}
