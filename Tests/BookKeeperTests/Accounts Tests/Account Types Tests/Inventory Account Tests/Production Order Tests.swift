import XCTest
import BookKeeper

// MARK: Production Order Processing

extension InventoryAccountTests {
    func testDebitProductionOrderWrongOrderTypeError() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

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
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .sample
        XCTAssertNoThrow(try inventory.debit(order: order))

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999 + 999)
        XCTAssertEqual(inventory.balance, 20_979 + 999 * 49)
        XCTAssertEqual(inventory.cost(), (20_979 + 999 * 49) / (999 + 999))
    }

    func testCreditProductionOrder() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try production order
        let order: ProductionOrder = .sample
        XCTAssertNoThrow(try inventory.credit(order: order))

        // confirm
        #warning("""
            what is the economic reason of debiting production order?
            does it make sense to debit production order?
            """)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

}
