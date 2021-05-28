import BookKeeper

extension Client {
    static let sample: Self = .init(name: "Client")
}

extension Supplier {
    static let sample: Self = .init(name: "Supplier")
}

extension RawMaterial {
    static let sample: Self = .init(inventory: InventoryAccount.init())
}

extension WorkInProgress {
    static let sample: Self = .init()
}

extension FinishedGood {
    static let sample: Self = .init(name: "Finished")
}

extension FixedAsset {
    static let sample: Self = .init(name: "Equipment", lifetime: 7, value: 999_999)
}

extension PurchaseOrder {
    static let sample: Self = .init(
        supplierID: Supplier.sample.id,
        orderType: .purchaseRawMaterial(RawMaterial.sample),
        qty: 9_999,
        priceExTax: 21.0,
        vatRate: 20 / 100
    )
}

import XCTest

final class HelpersTests: XCTestCase {
    func testClientSample() {
        XCTAssertNotEqual(Client.sample, Client(name: "Client"), "Should have different ID")
        XCTAssertNotEqual(Client.sample.id, Client(name: "Client").id, "Should have different ID")
        XCTAssertEqual(Client.sample.name, Client(name: "Client").name)
        XCTAssertEqual(Client.sample.receivables, Client(name: "Client").receivables)
    }

    func testSupplierSample() {
        XCTAssertNotEqual(Supplier.sample, Supplier(name: "Supplier"), "Should have different ID")
        XCTAssertNotEqual(Supplier.sample.id, Supplier(name: "Supplier").id, "Should have different ID")
        XCTAssertEqual(Supplier.sample.name, Supplier(name: "Supplier").name)
        XCTAssertEqual(Supplier.sample.payables, Supplier(name: "Supplier").payables)
    }

    func testRawMaterialSample() {
        XCTAssertNotEqual(RawMaterial.sample, RawMaterial(), "Should have different ID")
        XCTAssertNotEqual(RawMaterial.sample.id, RawMaterial().id, "Should have different ID")
        XCTAssertEqual(RawMaterial.sample.inventory, RawMaterial().inventory)
    }

    func testWorkInProgressSample() {
        XCTAssertNotEqual(WorkInProgress.sample, WorkInProgress(), "Should have different ID")
        XCTAssertNotEqual(WorkInProgress.sample.id, WorkInProgress().id, "Should have different ID")
        XCTAssertEqual(WorkInProgress.sample.inventory, WorkInProgress().inventory)
    }

    func testFinishedGoodSample() {
        let finishedGood = FinishedGood(name: "Finished")
        XCTAssertNotEqual(FinishedGood.sample, finishedGood, "Should have different ID")
        XCTAssertNotEqual(FinishedGood.sample.id, finishedGood.id, "Should have different ID")
        XCTAssertEqual(FinishedGood.sample.name, finishedGood.name)
        XCTAssertEqual(FinishedGood.sample.inventory, finishedGood.inventory)
        XCTAssertEqual(FinishedGood.sample.cogs, finishedGood.cogs)
        XCTAssertEqual(FinishedGood.sample.cost(), finishedGood.cost())
    }

    func testFixedAssetSample() {
        let fixedAsset: FixedAsset = .init(name: "Equipment", lifetime: 7, value: 999_999)
        XCTAssertNotEqual(FixedAsset.sample, fixedAsset, "Should have different ID")
        XCTAssertNotEqual(FixedAsset.sample.id, fixedAsset.id, "Should have different ID")
        XCTAssertEqual(FixedAsset.sample.name, fixedAsset.name)
        XCTAssertEqual(FixedAsset.sample.lifetime, fixedAsset.lifetime)
        XCTAssertEqual(FixedAsset.sample.value, fixedAsset.value)
        XCTAssertEqual(FixedAsset.sample.vatRate, fixedAsset.vatRate)
        XCTAssertEqual(FixedAsset.sample.depreciation, fixedAsset.depreciation)
        XCTAssertEqual(FixedAsset.sample.carryingAmount, fixedAsset.carryingAmount)
        XCTAssertEqual(FixedAsset.sample.depreciationAmountPerMonth, fixedAsset.depreciationAmountPerMonth)
    }

    func testPurchaseOrderSample() {
        let order = PurchaseOrder(supplierID: Supplier.sample.id,
                                  orderType: .purchaseRawMaterial(RawMaterial.sample),
                                  qty: 9_999,
                                  priceExTax: 21.0,
                                  vatRate: 20 / 100)
        XCTAssertEqual(PurchaseOrder.sample, order)
        XCTAssertEqual(PurchaseOrder.sample.supplierID, order.supplierID)
        XCTAssertEqual(PurchaseOrder.sample.orderType, order.orderType)
        XCTAssertEqual(PurchaseOrder.sample.qty, order.qty)
        XCTAssertEqual(PurchaseOrder.sample.priceExTax, order.priceExTax)
        XCTAssertEqual(PurchaseOrder.sample.cost, order.cost)
        XCTAssertEqual(PurchaseOrder.sample.vatRate, order.vatRate)
        XCTAssertEqual(PurchaseOrder.sample.vat, order.vat)
        XCTAssertEqual(PurchaseOrder.sample.amountExVAT, order.amountExVAT)
        XCTAssertEqual(PurchaseOrder.sample.amountWithVAT, order.amountWithVAT)
    }
}
