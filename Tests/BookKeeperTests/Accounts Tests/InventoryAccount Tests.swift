import XCTest
import BookKeeper

final class InventoryAccountTests: XCTestCase {
    func testInventoryAccountInit() {
        XCTAssertEqual(InventoryAccount.kind, .active)

        XCTAssertEqual(InventoryAccount.accountGroup,
                       .balanceSheet(.asset(.currentAsset(.inventory))))

        let inventoryAccountZero: InventoryAccount = .init()
        XCTAssertEqual(inventoryAccountZero.qty, 0)
        XCTAssertEqual(inventoryAccountZero.amount, 0)
        XCTAssertEqual(inventoryAccountZero.balance(), 0)
        XCTAssertEqual(inventoryAccountZero.group,
                       .balanceSheet(.asset(.currentAsset(.inventory))))

        let inventoryAccount: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.qty, 1_000)
        XCTAssertEqual(inventoryAccount.amount, 59_000)
        XCTAssertEqual(inventoryAccount.balance(), 59_000)
        XCTAssertEqual(inventoryAccount.group,
                       .balanceSheet(.asset(.currentAsset(.inventory))))
    }

    func testCost() {
        let inventoryAccountZero: InventoryAccount = .init()
        XCTAssertNil(inventoryAccountZero.cost())

        let inventoryAccount: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.cost(), 59)

        let inventory2: InventoryAccount = .init(qty: -100, amount: 1_000)
        XCTAssertEqual(inventory2.cost(), -10,
                       "For Modeling we allow negative qty, amount and cost")
    }

    func testDescription() {
        let inventoryAccountZero: InventoryAccount = .init()
        XCTAssertEqual(inventoryAccountZero.description,
                       "Inventory(amount: 0.0, qty: 0)")
        let inventoryAccount: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventoryAccount.description,
                       "Inventory(amount: 59000.0, qty: 1000)")
    }
}

// MARK: - Sales Order Processing
extension InventoryAccountTests {
    func testDebitSalesOrder() throws {
        // fill inventory by sales return
        var inventory: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()
        let order: SalesOrder = .init(orderType: .salesReturn(cost: 49),
                                      clientID: client.id,
                                      finishedGoodID: finishedGood.id,
                                      qty: 100,
                                      priceExTax: 99)
        XCTAssertNoThrow(try inventory.debit(order: order))

        // evaluate
        XCTAssertEqual(inventory.qty, 1_000 + 100)
        XCTAssertEqual(inventory.amount, 59 * 1_000 + 49 * 100)

        let cost = try XCTUnwrap(inventory.cost())
        XCTAssertEqual(cost, 58.090909, accuracy: 0.00001)

        // create another sales return order and add to inventory
        let orderSalesReturn2: SalesOrder = .init(orderType: .salesReturn(cost: 59),
                                       clientID: order.clientID,
                                       finishedGoodID: order.finishedGoodID,
                                       qty: 100,
                                       priceExTax: 99)
        XCTAssertNoThrow(try inventory.debit(order: orderSalesReturn2))

        // evaluate
        XCTAssertEqual(inventory.qty, 1_000 + 100 + 100)
        XCTAssertEqual(inventory.amount, 59.0 * 1_000 + 49.0 * 100 + 59.0 * 100)
        XCTAssertEqual(inventory.amount, 69_800)

        let cost2 = try XCTUnwrap(inventory.cost())
        XCTAssertEqual(cost2, 69_800.0 / 1_200, accuracy: 0.00001)
        XCTAssertEqual(cost2, 58.166666, accuracy: 0.00001)

        // try order that can't be processed
        let orderBookRevenue: SalesOrder = .init(orderType: .bookRevenue,
                                                 clientID: client.id,
                                                 finishedGoodID: finishedGood.id,
                                                 qty: 100,
                                                 priceExTax: 99)
        XCTAssertThrowsError(try inventory.debit(order: orderBookRevenue)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.wrongOrderType)
        }
    }

    func testCreditSalesOrderEmptyAccount() throws {
        // book revenue to empty inventory
        var inventory: InventoryAccount = .init()
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()
        let order: SalesOrder = .init(orderType: .bookRevenue,
                                      clientID: client.id,
                                      finishedGoodID: finishedGood.id,
                                      qty: 100,
                                      priceExTax: 99)
        XCTAssertThrowsError(try inventory.credit(order: order)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.emptyInventoryHasNoCost)
        }

        // evaluate
        XCTAssertEqual(inventory.qty, 0, "Crediting empty Inventory Account")
        XCTAssertEqual(inventory.amount, 0, "Crediting empty Inventory Account")
        XCTAssertNil(inventory.cost(), "Crediting empty Inventory Account")
    }

    func testCreditSalesOrderNonEmptyAccount() throws {
        // fill inventory
        var inventory: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()
        let order: SalesOrder = .init(orderType: .bookRevenue,
                                      clientID: client.id,
                                      finishedGoodID: finishedGood.id,
                                      qty: 100,
                                      priceExTax: 99)
        XCTAssertNoThrow(try inventory.credit(order: order))

        // evaluate
        XCTAssertEqual(inventory.qty, 900)
        XCTAssertEqual(inventory.amount, 59_000 - 59 * 100)
        XCTAssertEqual(inventory.cost(), 59, "Crediting inventory should not change cost")
    }

    func testCreditSalesOrderErrorType() {
        // initiate inventory
        var inventory: InventoryAccount = .init(qty: 1_000, amount: 59_000)
        XCTAssertEqual(inventory.cost(), 59)

        // create and try order that can't be processed
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()
        let qty = 100
        let priceExTax = 99.0

        let order: SalesOrder = .init(orderType: .salesReturn(cost: 99),
                                      clientID: client.id,
                                      finishedGoodID: finishedGood.id,
                                      qty: qty,
                                      priceExTax: priceExTax)

        XCTAssertThrowsError(try inventory.credit(order: order)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.wrongOrderType)
        }
    }
}

// MARK: - Inventory Order Processing
extension InventoryAccountTests {
    func testDebitInventoryOrder() throws {
        // fill inventory
        var inventory: InventoryAccount = .init()
        XCTAssertNil(inventory.cost())

        // add first order
        let finishedGood: FinishedGood = .init()
        let order1: InventoryOrder = .init(orderType: .produced(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           qty: 200)
        XCTAssertNoThrow(try inventory.debit(order: order1))

        // evaluate
        XCTAssertEqual(inventory.qty, 200)
        XCTAssertEqual(inventory.amount, 49 * 200)

        let cost1 = try XCTUnwrap(inventory.cost())
        XCTAssertEqual(cost1, 49, accuracy: 0.00001)

        // add second order
        let order2: InventoryOrder = .init(orderType: .produced(cost: 69),
                                           finishedGoodID: order1.finishedGoodID,
                                           qty: 500)
        XCTAssertNoThrow(try inventory.debit(order: order2))

        // evaluate
        XCTAssertEqual(inventory.qty, 200 + 500)
        XCTAssertEqual(inventory.amount, 49 * 200 + 69 * 500)

        let cost2 = try XCTUnwrap(inventory.cost())
        let c = Double(49 * 200 + 69 * 500) / Double(200 + 500)
        XCTAssertEqual(cost2, c, accuracy: 0.00001)
        XCTAssertEqual(cost2, 63.2857, accuracy: 0.001)

        // create and try order that can't be processed
        let order3: InventoryOrder = .init(orderType: .trashed,
                                           finishedGoodID: finishedGood.id,
                                           qty: 100)
        XCTAssertThrowsError(try inventory.debit(order: order3)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.wrongOrderType)
        }
    }

    func testCreditInventoryOrder() throws {
        // initiate empty inventory
        var inventory: InventoryAccount = .init()
        XCTAssertNil(inventory.cost())

        // add trash order
        let finishedGood: FinishedGood = .init()
        let trashInventoryOrder: InventoryOrder = .init(orderType: .trashed,
                                                        finishedGoodID: finishedGood.id,
                                                        qty: 100)
        XCTAssertThrowsError(try inventory.credit(order: trashInventoryOrder)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.emptyInventoryHasNoCost)
        }

        // evaluate
        XCTAssertEqual(inventory.qty, 0, "Should not be able to trash empty inventory.")
        XCTAssertEqual(inventory.amount, 0, "Should not be able to trash empty inventory.")
        XCTAssertNil(inventory.cost())

        // fill inventory
        let fillInventoryOrder: InventoryOrder = .init(orderType: .produced(cost: 49),
                                                       finishedGoodID: finishedGood.id,
                                                       qty: 200)
        XCTAssertNoThrow(try inventory.debit(order: fillInventoryOrder))

        // evaluate
        XCTAssertEqual(inventory.qty, 200)
        XCTAssertEqual(inventory.amount, 49 * 200)

        let cost1 = try XCTUnwrap(inventory.cost())
        XCTAssertEqual(cost1, 49, accuracy: 0.00001)

        // trash inventory
        XCTAssertNoThrow(try inventory.credit(order: trashInventoryOrder))

        // evaluate
        XCTAssertEqual(inventory.qty, 100)
        XCTAssertEqual(inventory.amount, 49 * 100)

        let cost2 = try XCTUnwrap(inventory.cost())
        XCTAssertEqual(cost2, 49, accuracy: 0.00001)

        // create and try order that can't be processed
        let order3: InventoryOrder = .init(orderType: .produced(cost: 88),
                                           finishedGoodID: finishedGood.id,
                                           qty: 100)
        XCTAssertThrowsError(try inventory.credit(order: order3)) { error in
            XCTAssertEqual(error as! InventoryAccount.OrderProcessingError,
                           InventoryAccount.OrderProcessingError.wrongOrderType)
        }
    }
}

// MARK: - Production Order Processing
extension InventoryAccountTests {
    func testDebitProductionOrder() throws {
        // initiate product with empty inventories
        var finishedGood: FinishedGood = .init()
        XCTAssert(finishedGood.inventory.isEmpty)

        // create production order
        let wip = WorkInProgress()
        let order: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           workInProgressID: wip.id,
                                           finishedGoodQty: 999)
        XCTAssertNoThrow(try finishedGood.inventory.debit(order: order))

        // confirm
        XCTAssertEqual(finishedGood.inventory.balance(), 999 * 49)
        XCTAssertEqual(finishedGood.inventory.amount, 999 * 49)
        XCTAssertEqual(finishedGood.inventory.qty, 999)
    }

    func testCreditProductionOrder() throws {
        // initiate product with empty inventories
        var finishedGood: FinishedGood = .init()
        XCTAssert(finishedGood.inventory.isEmpty)

        // create production order
        let wip = WorkInProgress()
        let order: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           workInProgressID: wip.id,
                                           finishedGoodQty: 999)
        XCTAssertNoThrow(try finishedGood.inventory.credit(order: order))

        // confirm
        XCTAssertEqual(finishedGood.inventory.balance(), -999 * 49)
        XCTAssertEqual(finishedGood.inventory.amount, -999 * 49)
        XCTAssertEqual(finishedGood.inventory.qty, -999)
    }

}
