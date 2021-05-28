import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    // swiftlint:disable function_body_length
    func testRecordFinishedGoods() throws {
        // initiate empty books
        var books: Books = .init()

        // initiate product with empty inventories
        let finishedGood: FinishedGood = .sample
        let workInProgress = WorkInProgress()

        // create production order with someOtherType
        let orderWithOtherType: ProductionOrder = .init(orderType: .someOtherType,
                                                        finishedGoodID: finishedGood.id,
                                                        workInProgressID: workInProgress.id,
                                                        finishedGoodQty: 999)

        // confirm
        XCTAssert(books.finishedGoods.totalBalance(for: \.inventory).isZero)
        XCTAssert(books.wips.totalBalance(for: \.inventory).isZero)

        XCTAssertThrowsError(try books.recordFinishedGoods(for: orderWithOtherType),
                             "Should fail: incorrect order type."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.incorrectOrderType)
        }

        // confirm no change after error
        XCTAssert(books.finishedGoods.totalBalance(for: \.inventory).isZero)
        XCTAssert(books.wips.totalBalance(for: \.inventory).isZero)

        // create production order
        let order: ProductionOrder = .init(orderType: .recordFinishedGoods(cost: 49),
                                           finishedGoodID: finishedGood.id,
                                           workInProgressID: workInProgress.id,
                                           finishedGoodQty: 999)

        XCTAssertThrowsError(
            try books.recordFinishedGoods(for: order),
            "Should fail since finishedGood is not in books."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        // confirm no change after error
        XCTAssert(books.finishedGoods.totalBalance(for: \.inventory).isZero)
        XCTAssert(books.wips.totalBalance(for: \.inventory).isZero)

        // add to books and try
        books.add(finishedGood: finishedGood)
        XCTAssertThrowsError(try books.recordFinishedGoods(for: order),
                             "Should fail since workInProgress is not in books."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownWorkInProgress)
        }

        // confirm no change after error
        XCTAssert(books.finishedGoods.totalBalance(for: \.inventory).isZero)
        XCTAssert(books.wips.totalBalance(for: \.inventory).isZero)

        // add and try
        books.add(workInProgress: workInProgress)
        XCTAssertNoThrow(try books.recordFinishedGoods(for: order))

        // confirm
        XCTAssert(books.rawMaterials.isEmpty)
        XCTAssertFalse(books.wips.isEmpty)
        XCTAssertFalse(books.finishedGoods.isEmpty)
        XCTAssert(books.clients.isEmpty)
        XCTAssert(books.revenueAccount.balanceIsZero)
        XCTAssert(books.taxLiabilities.balanceIsZero)

        let wipInventory = try XCTUnwrap(books.workInProgress(forID: workInProgress.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, -999)
        XCTAssertEqual(wipInventory.amount, 49 * -999)
        XCTAssertEqual(wipInventory.balance, 49 * -999)

        let finishedGoodInventory = try XCTUnwrap(books.finishedGood(forID: finishedGood.id)?.inventory)
        XCTAssertEqual(finishedGoodInventory.qty, 999)
        XCTAssertEqual(finishedGoodInventory.amount, 49 * 999)
        XCTAssertEqual(finishedGoodInventory.balance, 49 * 999)
    }
    // swiftlint:enable function_body_length
}
