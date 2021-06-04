import XCTest
import BookKeeper

final class InventoryAccountTests: XCTestCase {
    func testInventoryAccountInit() {
        XCTAssertEqual(InventoryAccount(type: .finishedGoods).kind, .active)

        XCTAssertEqual(InventoryAccount(type: .rawMaterials).group, .rawInventory)
        XCTAssertEqual(InventoryAccount(type: .workInProgress).group, .wipsInventory)
        XCTAssertEqual(InventoryAccount(type: .finishedGoods).group, .finishedInventory)

        let inventoryAccountZero: InventoryAccount = .init(type: .finishedGoods)
        XCTAssertEqual(inventoryAccountZero.qty, 0)
        XCTAssert(inventoryAccountZero.balanceIsZero)
        XCTAssertEqual(inventoryAccountZero.group, .finishedInventory)

        let inventoryAccount: InventoryAccount = .init(type: .finishedGoods, qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.qty, 1_000)
        XCTAssertEqual(inventoryAccount.balance, 59_000)
        XCTAssertEqual(inventoryAccount.group, .finishedInventory)
    }

    func testCost() {
        let inventoryAccountZero: InventoryAccount = .init(type: .finishedGoods)
        XCTAssertNil(inventoryAccountZero.cost())

        let inventoryAccount: InventoryAccount = .init(type: .finishedGoods, qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.cost(), 59)

        let inventoryAccount2: InventoryAccount = .init(type: .finishedGoods, qty: -100, amount: 1_000)
        XCTAssertEqual(inventoryAccount2.cost(), -10,
                       "For Modeling we allow negative qty, amount and cost")
    }

    func testDescription() {
        let inventoryAccountZero: InventoryAccount = .init(type: .finishedGoods)
        XCTAssertEqual(inventoryAccountZero.description,
                       "Inventory(qty: 0, amount: 0.0)")
        let inventoryAccount: InventoryAccount = .init(type: .finishedGoods, qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.description,
                       "Inventory(qty: 1000, amount: 59000.0)")
    }
}
