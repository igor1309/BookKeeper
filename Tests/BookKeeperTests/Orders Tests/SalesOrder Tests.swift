import XCTest
import BookKeeper

final class SalesOrderTests: XCTestCase {
    func testSalesOrderInit() {
        let client: Client = .init()
        let finishedGood: FinishedGood = .init()

        let salesOrderBookRevenue: SalesOrder = .init(orderType: .bookRevenue,
                                                      clientID: client.id,
                                                      finishedGoodID: finishedGood.id,
                                                      qty: 100,
                                                      priceExTax: 99)
        XCTAssertEqual(salesOrderBookRevenue.orderType, .bookRevenue)
        XCTAssertEqual(salesOrderBookRevenue.clientID, client.id)
        XCTAssertEqual(salesOrderBookRevenue.finishedGoodID, finishedGood.id)
        XCTAssertEqual(salesOrderBookRevenue.qty, 100)
        XCTAssertEqual(salesOrderBookRevenue.priceExTax, 99)
        XCTAssertEqual(salesOrderBookRevenue.taxRate, 0.2)
        XCTAssertEqual(salesOrderBookRevenue.tax, 100 * 99 * 0.2)
        XCTAssertEqual(salesOrderBookRevenue.amountExTax, 100 * 99)
        XCTAssertEqual(salesOrderBookRevenue.amountWithTax, 100 * 99 * (1 + 0.2))
        XCTAssertNil(salesOrderBookRevenue.cost)

        let salesOrderSalesReturn: SalesOrder = .init(orderType: .salesReturn(cost: 49),
                                                      clientID: client.id,
                                                      finishedGoodID: finishedGood.id,
                                                      qty: 100,
                                                      priceExTax: 99)
        XCTAssertEqual(salesOrderSalesReturn.orderType, .salesReturn(cost: 49))
        XCTAssertEqual(salesOrderSalesReturn.clientID, client.id)
        XCTAssertEqual(salesOrderSalesReturn.finishedGoodID, finishedGood.id)
        XCTAssertEqual(salesOrderSalesReturn.qty, 100)
        XCTAssertEqual(salesOrderSalesReturn.priceExTax, 99)
        XCTAssertEqual(salesOrderSalesReturn.taxRate, 0.2)
        XCTAssertEqual(salesOrderSalesReturn.tax, 100 * 99 * 0.2)
        XCTAssertEqual(salesOrderSalesReturn.amountExTax, 100 * 99)
        XCTAssertEqual(salesOrderSalesReturn.amountWithTax, 100 * 99 * (1 + 0.2))
        XCTAssertEqual(salesOrderSalesReturn.cost, 49)
    }
}
