import XCTest
import BookKeeper

final class InventoryOrderTests: XCTestCase {
    func testInit() {
        let finished: FinishedGood = .init(name: "FinishedGood")

        let orderProduced: InventoryOrder = .init(
            orderType: .produced(cost: 59),
            finishedGoodID: finished.id,
            qty: 500
        )
        XCTAssertEqual(orderProduced.orderType,
                       OrderType.produced(cost: 59))
        XCTAssertEqual(orderProduced.finishedGoodID, finished.id)
        XCTAssertEqual(orderProduced.qty, 500)
        XCTAssertEqual(orderProduced.cost, 59)

        let orderTrashed: InventoryOrder = .init(
            orderType: .trashed,
            finishedGoodID: finished.id,
            qty: 200
        )
        XCTAssertEqual(orderTrashed.orderType,
                       OrderType.trashed)
        XCTAssertEqual(orderTrashed.finishedGoodID, finished.id)
        XCTAssertEqual(orderTrashed.qty, 200)
        XCTAssertNil(orderTrashed.cost)
    }

    func testDescription() {
        let finished: FinishedGood = .init(name: "FinishedGood")

        let orderProduced: InventoryOrder = .init(
            orderType: .produced(cost: 59),
            finishedGoodID: finished.id,
            qty: 500
        )
        XCTAssertEqual(orderProduced.description,
                       "Sales Order(produced(cost: 59.0): 500)")

        let orderTrashed: InventoryOrder = .init(
            orderType: .trashed,
            finishedGoodID: finished.id,
            qty: 200
        )
        XCTAssertEqual(orderTrashed.description,
                       "Sales Order(trashed: 200)")
    }

}
