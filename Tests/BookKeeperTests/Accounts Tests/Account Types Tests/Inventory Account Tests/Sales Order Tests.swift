import XCTest
import BookKeeper

// MARK: Sales Order Processing

extension InventoryAccountTests {
    func testDebitSalesOrderWrongOrderType() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try order that can't be processed
        let orderBookRevenue: SalesOrder = .init(
            orderType: .bookRevenue,
            clientID: Client.sample.id,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100,
            priceExTax: 99
        )
        XCTAssertThrowsError(try inventory.debit(order: orderBookRevenue)) { error in
            XCTAssertEqual(error as? OrderProcessingError,
                           OrderProcessingError.wrongOrderType)
        }

        // confirm no change after error
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

    func testDebitSalesOrder() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try sales order
        let order: SalesOrder = .init(
            orderType: .salesReturn(cost: 49),
            clientID: Client.sample.id,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100,
            priceExTax: 99
        )
        XCTAssertNoThrow(try inventory.debit(order: order))

        // confirm
        XCTAssertEqual(inventory.qty, 999 + 100)
        XCTAssertEqual(inventory.amount, 20_979 + 100 * 49)
        let cost = try XCTUnwrap(inventory.cost())
        XCTAssertEqual((20_979 + 100 * 49) / (999 + 100), 23.54777, accuracy: 0.00001)
        XCTAssertEqual(cost, 23.54777, accuracy: 0.00001)
    }

    func testCreditSalesOrderEmptyAccountNoCostError() throws {
        // new inventory
        var inventory: InventoryAccount = .init(type: .finishedGoods)

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 0)
        XCTAssertEqual(inventory.balance, 0)
        XCTAssertNil(inventory.cost())

        // create and try sales order
        let order: SalesOrder = .init(
            orderType: .bookRevenue,
            clientID: Client.sample.id,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100,
            priceExTax: 99
        )
        XCTAssertThrowsError(
            try inventory.credit(order: order)
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

    func testCreditSalesOrderWrongOrderTypeError() {
        // initiate inventory
        var inventory: InventoryAccount = .init(type: .finishedGoods, qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventory.cost(), 59)

        // create and try order that can't be processed
        let client: Client = .sample
        let finishedGood: FinishedGood = .sample
        let qty = 100
        let priceExTax = 99.0

        let order: SalesOrder = .init(
            orderType: .salesReturn(cost: 99),
            clientID: client.id,
            finishedGoodID: finishedGood.id,
            qty: qty,
            priceExTax: priceExTax
        )

        XCTAssertThrowsError(try inventory.credit(order: order)) { error in
            XCTAssertEqual(error as? OrderProcessingError,
                           OrderProcessingError.wrongOrderType)
        }
    }

    func testCreditSalesOrderNonEmptyAccount() throws {
        // new inventory
        var inventory: InventoryAccount = .sample

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)

        // create and try sales order
        let order: SalesOrder = .init(
            orderType: .bookRevenue,
            clientID: Client.sample.id,
            finishedGoodID: FinishedGood.sample.id,
            qty: 100,
            priceExTax: 99
        )
        XCTAssertNoThrow(try inventory.credit(order: order))

        // confirm
        XCTAssertEqual(inventory.group, .finishedInventory)
        XCTAssertEqual(inventory.qty, 999 - 100)
        XCTAssertEqual(inventory.balance, 20_979 - 100 * 21)
        XCTAssertEqual(inventory.cost(), 21, "Crediting inventory should not change cost")
    }

}
