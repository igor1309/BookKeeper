import XCTest
import BookKeeper

final class ProductionOrderTests: XCTestCase {
    func testInit() {
        let finished: FinishedGood = .sample
        let workInProgress: WorkInProgress = .sample

        let orderRecordFinishedGoods: ProductionOrder = .init(
            orderType: .recordFinishedGoods(cost: 49),
            finishedGoodID: finished.id,
            workInProgressID: workInProgress.id,
            finishedGoodQty: 500
        )
        XCTAssertEqual(orderRecordFinishedGoods.orderType,
                       OrderType.recordFinishedGoods(cost: 49))
        XCTAssertEqual(orderRecordFinishedGoods.finishedGoodID, finished.id)
        XCTAssertEqual(orderRecordFinishedGoods.wipID, workInProgress.id)
        XCTAssertEqual(orderRecordFinishedGoods.qty, 500)
        XCTAssertEqual(orderRecordFinishedGoods.cost, 49)

        let orderSomeOtherType: ProductionOrder = .init(
            orderType: .someOtherType,
            finishedGoodID: finished.id,
            workInProgressID: workInProgress.id,
            finishedGoodQty: 200
        )
        XCTAssertEqual(orderSomeOtherType.orderType,
                       OrderType.someOtherType)
        XCTAssertEqual(orderSomeOtherType.finishedGoodID, finished.id)
        XCTAssertEqual(orderRecordFinishedGoods.wipID, workInProgress.id)
        XCTAssertEqual(orderSomeOtherType.qty, 200)
        XCTAssertNil(orderSomeOtherType.cost)
    }

    func testDescription() {
        let finished: FinishedGood = .sample
        let workInProgress: WorkInProgress = .sample

        let orderRecordFinishedGoods: ProductionOrder = .init(
            orderType: .recordFinishedGoods(cost: 49),
            finishedGoodID: finished.id,
            workInProgressID: workInProgress.id,
            finishedGoodQty: 500
        )
        XCTAssertEqual(orderRecordFinishedGoods.description,
                       "Production Order(recordFinishedGoods(cost: 49.0): 500)")

        let orderSomeOtherType: ProductionOrder = .init(
            orderType: .someOtherType,
            finishedGoodID: finished.id,
            workInProgressID: workInProgress.id,
            finishedGoodQty: 200
        )
        XCTAssertEqual(orderSomeOtherType.description,
                       "Production Order(someOtherType: 200)")
    }

}
