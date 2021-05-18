import XCTest
import BookKeeper

final class RevenueAccountTests: XCTestCase {
    func testRevenueAccountInit() {
        XCTAssertEqual(RevenueAccount.kind, .passive)

        XCTAssertEqual(RevenueAccount.accountGroup, .incomeStatement(.revenue))

        let revenueAccount0: RevenueAccount = .init()
        XCTAssertEqual(revenueAccount0.amount, 0)
        XCTAssertEqual(revenueAccount0.balance(), 0)
        XCTAssertEqual(revenueAccount0.group, .incomeStatement(.revenue))

        let revenueAccount1: RevenueAccount = .init(amount: 1_000)
        XCTAssertEqual(revenueAccount1.amount, 1_000)
        XCTAssertEqual(revenueAccount1.balance(), 1_000)
        XCTAssertEqual(revenueAccount1.group, .incomeStatement(.revenue))
    }

    func testDescription() {
        XCTAssertEqual(RevenueAccount().description,
                       "RevenueAccount(0.0)")
        XCTAssertEqual(RevenueAccount(amount: 10_000).description,
                       "RevenueAccount(10000.0)")
    }
}

// MARK: - Sales Order Processing
extension RevenueAccountTests {
    func testDebitSalesOrder() {
        // initiate zero revenue account
        var revenueAccount: RevenueAccount = .init()
        XCTAssertEqual(revenueAccount.balance(), 0)

        // create order and try to process (debit)
        let client = Client()
        let finishedGood = FinishedGood()

        let qty = 100
        let priceExVAT = 99.0

        let order = SalesOrder(orderType: .bookRevenue,
                               clientID: client.id,
                               finishedGoodID: finishedGood.id,
                               qty: qty,
                               priceExTax: priceExVAT)
        XCTAssertNoThrow(try revenueAccount.debit(salesOrder: order))

        // evaluate
        XCTAssertEqual(revenueAccount.amount, -order.tax)
        XCTAssertEqual(revenueAccount.balance(), -1980)

        // create and try order that can't be processed
        let order2 = SalesOrder(orderType: .salesReturn(cost: 10),
                                clientID: order.clientID,
                                finishedGoodID: order.finishedGoodID,
                                qty: qty,
                                priceExTax: priceExVAT)
        XCTAssertThrowsError(try revenueAccount.debit(salesOrder: order2)) { error in
            XCTAssertEqual(error as! RevenueAccount.SalesProcessingError,
                           RevenueAccount.SalesProcessingError.wrongSalesOrderType)
        }    }

    func testCreditSalesOrder() {
        // initiate zero revenue account
        var revenueAccount: RevenueAccount = .init()

        // create order and try to process (credit)
        let client = Client()
        let finishedGood = FinishedGood()

        let qty = 100
        let priceExVAT = 99.0

        let order = SalesOrder(orderType: .bookRevenue,
                               clientID: client.id,
                               finishedGoodID: finishedGood.id,
                               qty: qty,
                               priceExTax: priceExVAT)

        XCTAssertNoThrow(try revenueAccount.credit(salesOrder: order))

        // evaluate
        XCTAssertEqual(revenueAccount.amount, order.amountWithTax)
        XCTAssertEqual(revenueAccount.balance(), 11_880)

        // create and try order that can't be processed
        let order2 = SalesOrder(orderType: .salesReturn(cost: 10),
                                clientID: order.clientID,
                                finishedGoodID: order.finishedGoodID,
                                qty: qty,
                                priceExTax: priceExVAT)
        XCTAssertThrowsError(try revenueAccount.credit(salesOrder: order2)) { error in
            XCTAssertEqual(error as! RevenueAccount.SalesProcessingError,
                           RevenueAccount.SalesProcessingError.wrongSalesOrderType)
        }
    }

    func testDebitCreditSalesOrder() throws {
        // initiate zero revenue account
        var revenueAccount: RevenueAccount = .init()

        // create order and try to process (credit)
        let client = Client()
        let finishedGood = FinishedGood()

        let qty = 100
        let priceExVAT = 99.0

        let order = SalesOrder(orderType: .bookRevenue,
                               clientID: client.id,
                               finishedGoodID: finishedGood.id,
                               qty: qty,
                               priceExTax: priceExVAT)

        XCTAssertNoThrow(try revenueAccount.credit(salesOrder: order))
        XCTAssertNoThrow(try revenueAccount.debit(salesOrder: order))

        XCTAssertEqual(revenueAccount.amount, order.amountExTax)
        XCTAssertEqual(revenueAccount.amount, 9_900)
    }

}
