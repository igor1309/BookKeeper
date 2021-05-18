import XCTest
import BookKeeper

final class FinishedGoodTests: XCTestCase {

    func testFinishedGoodInit() {
        let finishedNoInventory: FinishedGood = .init()
        XCTAssertEqual(finishedNoInventory.inventory.qty, 0)
        XCTAssertEqual(finishedNoInventory.inventory.amount, 0)
        XCTAssertEqual(finishedNoInventory.inventory.balance(), 0)
        XCTAssertEqual(finishedNoInventory.cogs.amount, 0)
        XCTAssertEqual(finishedNoInventory.cogs.balance(), 0)

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(inventory: inventory, cogs: .init())
        XCTAssertEqual(finishedWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(finishedWithInventory.inventory.amount, 49_000)
        XCTAssertEqual(finishedWithInventory.inventory.balance(), 49_000)
        XCTAssertEqual(finishedWithInventory.cogs.amount, 0)
        XCTAssertEqual(finishedWithInventory.cogs.balance(), 0)

        let cogs: COGS = .init(amount: 2_200)
        let finishedWithInventoryAndCOGS: FinishedGood = .init(inventory: inventory, cogs: cogs)
        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.qty, 1_000)
        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.amount, 49_000)
        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.balance(), 49_000)
        XCTAssertEqual(finishedWithInventoryAndCOGS.cogs.amount, 2_200)
        XCTAssertEqual(finishedWithInventoryAndCOGS.cogs.balance(), 2_200)
    }

    func testCost() {
        let finishedNoInventory: FinishedGood = .init()
        XCTAssertNil(finishedNoInventory.cost())

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(inventory: inventory, cogs: COGS())
        XCTAssertEqual(finishedWithInventory.cost(), 49.0)

        let cogs: COGS = .init(amount: 2_200)
        let finishedWithInventoryAndCOGS: FinishedGood = .init(inventory: inventory, cogs: cogs)
        XCTAssertEqual(finishedWithInventoryAndCOGS.cost(), 49.0)
    }

    func testDescription() {
        let finishedNoInventory: FinishedGood = .init()
        XCTAssertEqual(finishedNoInventory.description,
                       "FinishedGood(inventory: Inventory(amount: 0.0, qty: 0), cogs: COGS(0.0))")

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(inventory: inventory, cogs: .init())
        XCTAssertEqual(finishedWithInventory.description,
                       "FinishedGood(inventory: Inventory(amount: 49000.0, qty: 1000), cogs: COGS(0.0))")

        let cogs: COGS = .init(amount: 2_200)
        let finishedWithInventoryAndCOGS: FinishedGood = .init(inventory: inventory, cogs: cogs)
        XCTAssertEqual(finishedWithInventoryAndCOGS.description,
                       "FinishedGood(inventory: Inventory(amount: 49000.0, qty: 1000), cogs: COGS(2200.0))")
    }

}
