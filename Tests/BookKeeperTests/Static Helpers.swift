@testable import BookKeeper

extension Books {
    static let sample: Self = .init(
        ledger: [
            .init(group: .cash, amount: 1_000_000),
            .init(group: .loan, amount: 800_000),
            .init(group: .stocks, amount: 200_000)
        ]
    )
}

extension Client {
    static let sample: Self = .init(name: "Client", initialReceivables: 66_666)
}

extension Supplier {
    static let sample: Self = .init(name: "Supplier", initialPayables: 37_555)
}

extension RawMaterial {
    static let sample: Self = .init(
        name: "RawMaterial",
        initialInventoryQty: 1_000,
        initialInventoryValue: 37_555
    )
}

extension WorkInProgress {
    static let sample: Self = .init(
        name: "WorkInProgress",
        initialInventoryQty: 1_000,
        initialInventoryValue: 77_777
    )
}

extension FinishedGood {
    static let sample: Self = .init(
        name: "Finished Good with Inventory",
        initialInventoryQty: 1_000,
        initialInventoryValue: 49_000,
        initialCOGS: 35_000
    )
}

extension Equipment {
    static let sample: Self = .init(
        name: "Equipment", lifetime: 7, value: 999_999, depreciation: 47_619
    )
}

extension SalesOrder {
    static let bookRevenue: Self = .init(
        orderType: .bookRevenue,
        clientID: Client.sample.id,
        finishedGoodID: FinishedGood.sample.id,
        qty: 100,
        priceExTax: 99.0
    )
}

extension PurchaseOrder {
    static let purchaseRawMaterial: Self = .init(
        supplierID: Supplier.sample.id,
        orderType: .purchaseRawMaterial(RawMaterial.sample),
        qty: 9_999,
        priceExTax: 21.0,
        vatRate: 20/100
    )
}

extension ProductionOrder {
    static let recordFinishedGoods: Self = .init(
        orderType: .recordFinishedGoods(cost: 49),
        finishedGoodID: FinishedGood.sample.id,
        workInProgressID: WorkInProgress.sample.id,
        finishedGoodQty: 444
    )

    #warning("""
        this is not a ProductionOrder, this is InventoryOrder

        example of common OrderType usage - it would be safer to use
        order type inside each of ProductionOrder/SalesOrder, etc
        but that would kill debit and credit funcs that are generic
        over Order: OrderProtocol and we should create debit/credit for each
        type (ProductionOrder/SalesOrder, etc)

        so we have to deal with this complexity by additional checking
        inside debit/credit funcs
        """)
    static let trash: Self = .init(
        orderType: .trash,
        finishedGoodID: FinishedGood.sample.id,
        workInProgressID: WorkInProgress.sample.id,
        finishedGoodQty: 333
    )

    #warning("""
        this is not a ProductionOrder, this is InventoryOrder

        example of common OrderType usage - it would be safer to use
        order type inside each of ProductionOrder/SalesOrder, etc
        but that would kill debit and credit funcs that are generic
        over Order: OrderProtocol and we should create debit/credit for each
        type (ProductionOrder/SalesOrder, etc)

        so we have to deal with this complexity by additional checking
        inside debit/credit funcs
        """)
    static let bookRevenue: Self = .init(
        orderType: .bookRevenue,
        finishedGoodID: FinishedGood.sample.id,
        workInProgressID: WorkInProgress.sample.id,
        finishedGoodQty: 555
    )
}

extension InventoryAccount {
    static let finishedInventory: Self = .init(
        type: .finishedGoods,
        qty: 999,
        amount: 20_979
    )
    static let wipsInventory: Self = .init(
        type: .workInProgress,
        qty: 999,
        amount: 20_979
    )
}

import XCTest

final class HelpersTests: XCTestCase {
    func testBooksSample() {
        let books: Books = .sample

        XCTAssert(books.rawMaterials.isEmpty)
        XCTAssert(books.wips.isEmpty)
        XCTAssert(books.finishedGoods.isEmpty)
        XCTAssert(books.clients.isEmpty)
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.equipments.isEmpty)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.cash]?.balance, 1_000_000)
        XCTAssertEqual(books.ledger[.loan]?.balance, 800_000)
        XCTAssertEqual(books.ledger[.stocks]?.balance, 200_000)
    }

    func testClientSample() {
        let client: Client = .sample

        XCTAssertNotEqual(client, Client(name: "Client"), "Should have different ID")
        XCTAssertNotEqual(client.id, Client(name: "Client").id, "Should have different ID")
        XCTAssertEqual(client.name, "Client")
        XCTAssertEqual(client.receivables, Account(group: .receivables, amount: 66_666))
        XCTAssertEqual(client.receivables.kind, .active)
        XCTAssertEqual(client.receivables.group, .receivables)
        XCTAssertEqual(client.receivables.balance, 66_666)
    }

    func testSupplierSample() {
        let supplier: Supplier = .sample

        XCTAssertNotEqual(supplier, Supplier(name: "Supplier"), "Should have different ID")
        XCTAssertNotEqual(supplier.id, Supplier(name: "Supplier").id, "Should have different ID")
        XCTAssertEqual(supplier.name, "Supplier")
        XCTAssertEqual(supplier.payables, Account(group: .payables, amount: 37_555))
        XCTAssertEqual(supplier.payables.kind, .passive)
        XCTAssertEqual(supplier.payables.group, .payables)
        XCTAssertEqual(supplier.payables.balance, 37_555)
    }

    func testRawMaterialSample() {
        let rawMaterial: RawMaterial = .sample

        XCTAssertNotEqual(rawMaterial, RawMaterial(name: "RawMaterial"), "Should have different ID")
        XCTAssertNotEqual(rawMaterial.id, RawMaterial(name: "RawMaterial").id, "Should have different ID")

        XCTAssertEqual(rawMaterial.inventory,
                       InventoryAccount(type: .rawMaterials, qty: 1_000, amount: 37_555))
        XCTAssertEqual(rawMaterial.inventory.kind, .active)
        XCTAssertEqual(rawMaterial.inventory.type, .rawMaterials)
        XCTAssertEqual(rawMaterial.inventory.qty, 1_000)
        XCTAssertEqual(rawMaterial.inventory.balance, 37_555)
    }

    func testWorkInProgressSample() {
        let workInProgress: WorkInProgress = .sample

        XCTAssertNotEqual(workInProgress, WorkInProgress(name: "WorkInProgress"), "Should have different ID")
        XCTAssertNotEqual(workInProgress.id, WorkInProgress(name: "WorkInProgress").id, "Should have different ID")

        XCTAssertEqual(workInProgress.inventory,
                       InventoryAccount(type: .workInProgress, qty: 1_000, amount: 77_777))
        XCTAssertEqual(workInProgress.inventory.kind, .active)
        XCTAssertEqual(workInProgress.inventory.type, .workInProgress)
        XCTAssertEqual(workInProgress.inventory.qty, 1_000)
        XCTAssertEqual(workInProgress.inventory.balance, 77_777)
    }

    func testFinishedGoodSample() {
        let finishedGood: FinishedGood = .sample

        XCTAssertNotEqual(finishedGood, FinishedGood(name: "Finished Good with Inventory"),
                          "Should have different ID")
        XCTAssertNotEqual(finishedGood.id, FinishedGood(name: "Finished Good with Inventory").id,
                          "Should have different ID")

        XCTAssertEqual(finishedGood.name, "Finished Good with Inventory")
        XCTAssertEqual(finishedGood.inventory,
                       InventoryAccount(type: .finishedGoods, qty: 1_000, amount: 49_000))
        XCTAssertEqual(finishedGood.inventory.kind, .active)
        XCTAssertEqual(finishedGood.inventory.type, .finishedGoods)
        XCTAssertEqual(finishedGood.inventory.qty, 1_000)
        XCTAssertEqual(finishedGood.inventory.balance, 49_000)

        XCTAssertEqual(finishedGood.cogs, Account(group: .cogs, amount: 35_000))
        XCTAssertEqual(finishedGood.cogs.kind, .active)
        XCTAssertEqual(finishedGood.cogs.group, .cogs)
        XCTAssertEqual(finishedGood.cogs.balance, 35_000)

        XCTAssertEqual(finishedGood.cost(), 49)
    }

    func testEquipmentSample() {
        let equipment: Equipment = .sample

        XCTAssertNotEqual(equipment,
                          Equipment(name: "Equipment", lifetime: 7, value: 999_999, depreciation: 47_619),
                          "Should have different ID")
        XCTAssertNotEqual(equipment.id,
                          Equipment(name: "Equipment", lifetime: 7, value: 999_999, depreciation: 47_619).id,
                          "Should have different ID")

        XCTAssertEqual(equipment.name, "Equipment")
        XCTAssertEqual(equipment.lifetime, 7)
        XCTAssertEqual(equipment.initialValue, 999_999)
        XCTAssertEqual(equipment.vatRate, 20/100)
        XCTAssertEqual(equipment.depreciation, 47_619)
        XCTAssertEqual(equipment.carryingAmount, 999_999 - 47_619)
        XCTAssertEqual(equipment.depreciationAmountPerMonth, 11_904.75)
    }

    func testSalesOrderSample() {
        let order: SalesOrder = .bookRevenue

        XCTAssertEqual(order.orderType, .bookRevenue)
        XCTAssertEqual(order.clientID, Client.sample.id)
        XCTAssertEqual(order.finishedGoodID, FinishedGood.sample.id)
        XCTAssertEqual(order.priceExTax, 99)
        XCTAssertEqual(order.cost, 99)
        XCTAssertEqual(order.qty, 100)
        XCTAssertEqual(order.priceExTax, 99)
        XCTAssertEqual(order.taxRate, 20/100)
        XCTAssertEqual(order.tax, 100 * 99 * 0.2)
        XCTAssertEqual(order.amountExTax, 100 * 99)
        XCTAssertEqual(order.amountWithTax, 100 * 99 * (1 + 20/100))
    }

    func testPurchaseOrderSample() {
        let order: PurchaseOrder = .purchaseRawMaterial

        XCTAssertEqual(order.supplierID, Supplier.sample.id)
        XCTAssertEqual(order.orderType, .purchaseRawMaterial(RawMaterial.sample))
        XCTAssertEqual(order.qty, 9_999)
        XCTAssertEqual(order.priceExTax, 21.0)
        XCTAssertEqual(order.cost, 21)
        XCTAssertEqual(order.vatRate, 20/100)
        XCTAssertEqual(order.vat, 41_995.8)
        XCTAssertEqual(order.vat, 9_999 * 21 * 20 / 100)
        XCTAssertEqual(order.amountExVAT, 209_979.0)
        XCTAssertEqual(order.amountExVAT, 9_999 * 21)
        XCTAssertEqual(order.amountWithVAT, 251_974.8)
        XCTAssertEqual(order.amountWithVAT, 9_999 * 21 * (1 + 20/100))
    }

    func testProductionOrderSampleRecordFinishedGoods() {
        let order: ProductionOrder = .recordFinishedGoods

        XCTAssertEqual(order.orderType, .recordFinishedGoods(cost: 49))
        XCTAssertEqual(order.qty, 444)
        XCTAssertEqual(order.finishedGoodID, FinishedGood.sample.id)
        XCTAssertEqual(order.wipID, WorkInProgress.sample.id)
        XCTAssertEqual(order.cost, 49)
    }

    func testProductionOrderSampleTrash() {
        let order: ProductionOrder = .trash

        XCTAssertEqual(order.orderType, .trash)
        XCTAssertEqual(order.qty, 333)
        XCTAssertEqual(order.finishedGoodID, FinishedGood.sample.id)
        XCTAssertEqual(order.wipID, WorkInProgress.sample.id)
        XCTAssertEqual(order.cost, nil)
    }

    func testProductionOrderSampleBookRevenue() {
        let order: ProductionOrder = .bookRevenue

        XCTAssertEqual(order.orderType, .bookRevenue)
        XCTAssertEqual(order.qty, 555)
        XCTAssertEqual(order.finishedGoodID, FinishedGood.sample.id)
        XCTAssertEqual(order.wipID, WorkInProgress.sample.id)
        XCTAssertEqual(order.cost, nil)
    }

    func testInventoryAccountSample() throws {
        let inventory: InventoryAccount = .finishedInventory

        XCTAssertEqual(inventory.kind, .active)
        XCTAssertEqual(inventory.type, .finishedGoods)
        XCTAssertEqual(inventory.qty, 999)
        XCTAssertEqual(inventory.amount, 20_979)
        XCTAssertEqual(inventory.balance, 20_979)
        XCTAssertEqual(inventory.cost(), 21.0)
    }

}
