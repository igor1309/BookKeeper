import XCTest
import BookKeeper

final class ProductionOrderTests: XCTestCase {
    func testInit() throws {
        let finished: FinishedGood = .sample
        let workInProgress: WorkInProgress = .sample

        let orderRecordFinishedGoods: ProductionOrder = .recordFinishedGoods
        XCTAssertEqual(orderRecordFinishedGoods.orderType,
                       OrderType.recordFinishedGoods(cost: 49))
        XCTAssertEqual(orderRecordFinishedGoods.finishedGoodID, finished.id)
        XCTAssertEqual(orderRecordFinishedGoods.wipID, workInProgress.id)
        XCTAssertEqual(orderRecordFinishedGoods.qty, 444)
        XCTAssertEqual(orderRecordFinishedGoods.cost, 49)

        let orderSomeOtherType: ProductionOrder = .someOtherType
        XCTAssertEqual(orderSomeOtherType.orderType,
                       OrderType.someOtherType)
        XCTAssertEqual(orderSomeOtherType.finishedGoodID, finished.id)
        XCTAssertEqual(orderRecordFinishedGoods.wipID, workInProgress.id)
        XCTAssertEqual(orderSomeOtherType.qty, 200)
        XCTAssertNil(orderSomeOtherType.cost)
    }

    func testDescription() throws {
        let orderRecordFinishedGoods: ProductionOrder = .recordFinishedGoods
        XCTAssertEqual(orderRecordFinishedGoods.description,
                       "Production Order(recordFinishedGoods(cost: 49.0): 444)")

        let orderSomeOtherType: ProductionOrder = .someOtherType
        XCTAssertEqual(orderSomeOtherType.description,
                       "Production Order(someOtherType: 200)")
    }

}
