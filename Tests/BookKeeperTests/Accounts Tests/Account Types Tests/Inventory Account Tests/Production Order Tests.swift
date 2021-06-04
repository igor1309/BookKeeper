import XCTest
import BookKeeper

// MARK: Production Order Processing

extension InventoryAccountTests {
    func testDebitProductionOrderWrongOrderTypeError() throws {
        // new inventory
        var inventory: InventoryAccount = .finishedInventory

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .init(
            orderType: .bookRevenue,
            finishedGoodID: FinishedGood.sample.id,
            workInProgressID: WorkInProgress.sample.id,
            finishedGoodQty: 888
        )
        XCTAssertThrowsError(
            try inventory.debit(order: order)
        ) { error in
            XCTAssertEqual(error as? OrderProcessingError,
                           OrderProcessingError.wrongOrderType)
        }

        // confirm no change after error
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

    func testDebitProductionOrderNoError() {
        // new inventory
        var inventory: InventoryAccount = .finishedInventory

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .recordFinishedGoods
        XCTAssertNoThrow(try inventory.debit(order: order))

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999 + 444)
        XCTAssertEqual(inventory.balance, 20_979 + 444 * 49)
        XCTAssertEqual(inventory.cost(), (20_979 + 444 * 49) / (999 + 444))
    }

    func testCreditProductionOrderFinishedInventoryNoError() throws {
        // new inventory
        var inventory: InventoryAccount = .wipsInventory

        // confirm
        XCTAssertEqual(inventory.group, .wipsInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .recordFinishedGoods
        XCTAssertNoThrow(try inventory.credit(order: order))

        // confirm
        XCTAssertEqual(inventory.group, .wipsInventory)
        XCTAssertEqual(inventory.qty, 999 - 444)
        XCTAssertEqual(inventory.balance, 20_979 - 444 * 21)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

    func testCreditProductionOrderTrashNoError() throws {
        // new inventory
        var inventory: InventoryAccount = .finishedInventory

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .trash
        XCTAssertNoThrow(try inventory.credit(order: order))

        // confirm
        XCTAssertEqual(inventory.qty, 666)
        XCTAssertEqual(inventory.balance, 20_979 - 333 * 21)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

    func testCreditProductionOrderBookRevenueNoError() throws {
        // new inventory
        var inventory: InventoryAccount = .finishedInventory

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .bookRevenue
        XCTAssertNoThrow(try inventory.credit(order: order))

        // confirm
        XCTAssertEqual(inventory.qty, 999 - 555)
        XCTAssertEqual(inventory.balance, 20_979 - 555 * 21)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

}
