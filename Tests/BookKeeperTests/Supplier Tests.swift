import XCTest
import BookKeeper

final class SupplierTests: XCTestCase {
    func testSupplierInit() {
        let supplierZero: Supplier = .init(name: "Supplier0")
        XCTAssert(supplierZero.payables.balanceIsZero)

        let supplier: Supplier = Supplier(name: "Supplier", initialPayables: 9_900)
        XCTAssertEqual(supplier.payables.balance, 9_900)
    }

    func testDescription() {
        let supplierZero: Supplier = .init(name: "Supplier0")
        XCTAssertEqual(supplierZero.description,
                       "Supplier Supplier0(payables: Supplier0(Accounts Payable (passive); 0.0))")

        let supplier: Supplier = Supplier(name: "Supplier", initialPayables: 9_900)
        XCTAssertEqual(supplier.description,
                       "Supplier Supplier(payables: Supplier(Accounts Payable (passive); 9900.0))")
    }

}
