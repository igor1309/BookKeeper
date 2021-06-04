import XCTest
import BookKeeper

final class PurchaseOrderTests: XCTestCase {
    func testSample() {
        let order: PurchaseOrder = .purchaseRawMaterial

        XCTAssertEqual(order.amountExVAT, 209_979.0)
        XCTAssertEqual(order.amountWithVAT, 251_974.8)
        XCTAssertEqual(order.priceExTax, 21)
        XCTAssertEqual(order.qty, 9_999)
        XCTAssertEqual(order.vat, 41_995.8)
        XCTAssertEqual(order.vatRate, 0.2)
        XCTAssertEqual(order.cost, 21)
        XCTAssertEqual(order.orderType, .purchaseRawMaterial(.sample))
        XCTAssertEqual(order.supplierID, Supplier.sample.id)

    }
}
