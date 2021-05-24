import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testRecordFinishedGoods() throws {
        // initiate empty books
        var books: Books = .init()

        // initiate product with empty inventories
        let finishedGood: FinishedGood = .init()
        let workInProgress = WorkInProgress()

        // create production order with someOtherType
        let orderWithOtherType: ProductionOrder = .init(orderType: .someOtherType,
                                                        finishedGoodID: finishedGood.id,
                                                        workInProgressID: workInProgress.id,
                                                        finishedGoodQty: 999)

        XCTAssertThrowsError(try books.recordFinishedGoods(for: orderWithOtherType),
                             "Should fail: incorrect order type."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.incorrectOrderType)
        }

        // create production order
        let order: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           workInProgressID: workInProgress.id,
                                           finishedGoodQty: 999)

        XCTAssertThrowsError(try books.recordFinishedGoods(for: order),
                             "Should fail since finishedGood is not in books."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }
        // add to books
        books.add(finishedGood: finishedGood)
        XCTAssertThrowsError(try books.recordFinishedGoods(for: order),
                             "Should fail since workInProgress is not in books."
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownWorkInProgress)
        }

        books.add(workInProgress: workInProgress)
        XCTAssertNoThrow(try books.recordFinishedGoods(for: order))

        // confirm
        XCTAssert(books.rawMaterialsAll().isEmpty)
        XCTAssertFalse(books.wipsAll().isEmpty)
        XCTAssertFalse(books.finishedGoodsAll().isEmpty)
        XCTAssert(books.clientsAll().isEmpty)
        XCTAssertEqual(books.revenueAccountBalance, 0)
        XCTAssertEqual(books.taxLiabilitiesBalance, 0)

        let wipInventory = try XCTUnwrap(books.workInProgress(forID: workInProgress.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, -999)
        XCTAssertEqual(wipInventory.amount, 49 * -999)
        XCTAssertEqual(wipInventory.balance(), 49 * -999)

        let finishedGoodInventory = try XCTUnwrap(books.finishedGood(forID: finishedGood.id)?.inventory)
        XCTAssertEqual(finishedGoodInventory.qty, 999)
        XCTAssertEqual(finishedGoodInventory.amount, 49 * 999)
        XCTAssertEqual(finishedGoodInventory.balance(), 49 * 999)
    }
}
