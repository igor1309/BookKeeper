import XCTest
import BookKeeper

final class FinishedGoodTests: XCTestCase {

    func testFinishedGoodInit() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertEqual(finishedNoInventory.inventory.qty, 0)
        XCTAssertEqual(finishedNoInventory.inventory.amount, 0)
        XCTAssertEqual(finishedNoInventory.inventory.balance(), 0)
        XCTAssertEqual(finishedNoInventory.cogs.amount, 0)
        XCTAssertEqual(finishedNoInventory.cogs.balance(), 0)

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(
            name: "Finished Good with Inventory",
            inventory: inventory
        )
        XCTAssertEqual(finishedWithInventory.inventory.qty, 1_000)
        XCTAssertEqual(finishedWithInventory.inventory.amount, 49_000)
        XCTAssertEqual(finishedWithInventory.inventory.balance(), 49_000)
        XCTAssertEqual(finishedWithInventory.cogs.amount, 0)
        XCTAssertEqual(finishedWithInventory.cogs.balance(), 0)

        #warning("no cogs in init any more")
//        let cogs: SimpleAccount = .cogsAccount(amount: 2_200)
//        let finishedWithInventoryAndCOGS: FinishedGood = .init(
//            inventory: inventory,
//            name: "Finished Good with Inventory and COGS",
//            cogs: cogs)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.qty, 1_000)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.amount, 49_000)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.inventory.balance(), 49_000)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.cogs.amount, 2_200)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.cogs.balance(), 2_200)
    }

    func testCost() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertNil(finishedNoInventory.cost())

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(name: "Finished", inventory: inventory)
        XCTAssertEqual(finishedWithInventory.cost(), 49.0)

        #warning("no cogs in init any more")
//        let cogs: SimpleAccount = .cogsAccount(amount: 2_200)
//        let finishedWithInventoryAndCOGS: FinishedGood = .init(inventory: inventory, cogs: cogs)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.cost(), 49.0)
    }

    func testDescription() {
        let finishedNoInventory: FinishedGood = .init(name: "Finished good without Inventory")
        XCTAssertEqual(finishedNoInventory.description,
                       "FinishedGood 'Finished good without Inventory'\n\tinventory: Inventory(qty: 0, amount: 0.0)\n\tcogs: Finished good without Inventory(COGS (active); 0.0))")

        let inventory: InventoryAccount = .init(qty: 1_000, amount: 49_000)
        let finishedWithInventory: FinishedGood = .init(
            name: "Finished Good with Inventory",
            inventory: inventory
        )
        XCTAssertEqual(finishedWithInventory.description,
                       "FinishedGood 'Finished Good with Inventory'\n\tinventory: Inventory(qty: 1000, amount: 49000.0)\n\tcogs: Finished Good with Inventory(COGS (active); 0.0))")

        #warning("no cogs in init any more")
//        let cogs: COGS = .init(amount: 2_200)
//        let finishedWithInventoryAndCOGS: FinishedGood = .init(inventory: inventory, cogs: cogs)
//        XCTAssertEqual(finishedWithInventoryAndCOGS.description,
//                       "FinishedGood(inventory: Inventory(amount: 49000.0, qty: 1000), cogs: COGS(2200.0))")
    }

}
