import XCTest
import BookKeeper

// MARK: Inventory Order Processing

extension InventoryAccountTests {
    func testDebitInventoryOrderWrongOrderTypeError() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try order that can't be processed
        let order3: InventoryOrder = .init(
            orderType: .trash,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100
        )
        XCTAssertThrowsError(
            try inventory.debit(order: order3)
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

    func testDebitInventoryOrder() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try order
        let finishedGood: FinishedGood = .sample
        let order1: InventoryOrder = .init(
            orderType: .produced(cost: 49),
            finishedGoodID: finishedGood.id,
            qty: 200
        )
        XCTAssertNoThrow(try inventory.debit(order: order1))

        // confirm
        XCTAssertEqual(inventory.qty, 999 + 200)
        XCTAssertEqual(inventory.balance, 20_979 + 200 * 49)
        XCTAssertEqual(inventory.cost(), (20_979 + 200 * 49) / (999 + 200))
    }

    func testCreditInventoryOrderWrongOrderTypeError() {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try order that can't be processed
        let order3: InventoryOrder = .init(
            orderType: .produced(cost: 88),
            finishedGoodID: FinishedGood.sample.id,
            qty: 100
        )
        XCTAssertThrowsError(
            try inventory.credit(order: order3)
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

    func testCreditInventoryOrderEmptyInventoryHasNoCostError() throws {
        // initiate empty inventory
        var inventory: InventoryAccount = .init(type: .finishedGoods)

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 0)
        XCTAssertEqual(inventory.balance, 0)
        XCTAssertNil(inventory.cost())

        // try trash order
        let trashInventoryOrder: InventoryOrder = .init(
            orderType: .trash,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100
        )
        XCTAssertThrowsError(
            try inventory.credit(order: trashInventoryOrder)
        ) { error in
            XCTAssertEqual(error as? OrderProcessingError,
                           OrderProcessingError.noCost)
        }

        // confirm no change after error
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 0)
        XCTAssertEqual(inventory.balance, 0)
        XCTAssertNil(inventory.cost())
    }

    func testCreditInventoryOrder() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try order
        let trashInventoryOrder: InventoryOrder = .init(
            orderType: .trash,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100
        )
        XCTAssertNoThrow(try inventory.credit(order: trashInventoryOrder))

        // confirm
        XCTAssertEqual(inventory.qty, 999 - 100)
        XCTAssertEqual(inventory.balance, 20_979 - 100 * 21)
        XCTAssertEqual(inventory.cost(), 21, "Should be no change in inventory cost")
    }

}
