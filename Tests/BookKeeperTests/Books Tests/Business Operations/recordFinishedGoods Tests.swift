import XCTest
import BookKeeper

// MARK: Business Operations

extension BooksTests {
    // swiftlint:disable function_body_length
    #warning("not sure this test is finished")
    func testRecordFinishedGoodsIncorrectOrderTypeError() {
        // initiate empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // create production order with someOtherType
        let orderWithOtherType: ProductionOrder = .init(
            orderType: .someOtherType,
            finishedGoodID: FinishedGood.sample.id,
            workInProgressID: WorkInProgress.sample.id,
            finishedGoodQty: 999)

        XCTAssertThrowsError(
            try books.recordFinishedGoods(for: orderWithOtherType),
            "Should fail: incorrect order type."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.incorrectOrderType)
        }

        // confirm no change after error
        XCTAssert(books.isEmpty)
    }

    #warning("make test for negative finishedGoodQty: 999")
    #warning("should ProductionOrder have throwing init? for ex, nonPositive qty?")

    func testRecordFinishedGoodsUnknownFinishedGoodError() {
        // initiate empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // create production order
        let order: ProductionOrder = .sample

        // try record finished goods
        XCTAssertThrowsError(
            try books.recordFinishedGoods(for: order),
            "Should fail since finishedGood is not in books."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownFinishedGood)
        }

        // confirm no change after error
        XCTAssert(books.isEmpty)
    }

    func testRecordFinishedGoodsUnknownWorkInProgressError() {
        // initiate books with finished goods
        let finishedGood: FinishedGood = .sample
        var books: Books = .init(finishedGoods: finishedGood)

        // confirm
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)
        XCTAssert(books.wips.isEmpty)

        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)

        // create production order
        let order: ProductionOrder = .sample

        // try record finished goods
        XCTAssertThrowsError(
            try books.recordFinishedGoods(for: order),
            "Should fail since workInProgress is not in books."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownWorkInProgress)
        }

        // confirm no change after error
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)
        XCTAssert(books.wips.isEmpty)

        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)
    }

    func testRecordFinishedGoodsInsufficientBalanceForWorkInProgressInventoryError() throws {
        // initiate books with work in progress and finished goods
        let finishedGood: FinishedGood = .sample
        let workInProgress: WorkInProgress = .sample
        var books: Books = .init(
            wips: workInProgress,
            finishedGoods: finishedGood
        )

        // confirm
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory), 77_777)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 77_777)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)

        // create huge production order
        let order: ProductionOrder = .init(
            orderType: .recordFinishedGoods(cost: 49),
            finishedGoodID: FinishedGood.sample.id,
            workInProgressID: WorkInProgress.sample.id,
            finishedGoodQty: 1_999_999
        )

        // try record finished goods
        XCTAssertThrowsError(
            try books.recordFinishedGoods(for: order)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           .insufficientBalance(.wipsInventory))
        }

        // confirm no change after error
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory), 77_777)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 77_777)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)
    }

    func testRecordFinishedGoods() throws {
        // initiate books with work in progress and finished goods
        let finishedGood: FinishedGood = .sample
        let workInProgress: WorkInProgress = .sample
        var books: Books = .init(
            wips: workInProgress,
            finishedGoods: finishedGood
        )

        // confirm
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory), 49_000)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory), 77_777)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 77_777)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)

        // create production order
        let order: ProductionOrder = .sample

        // try record finished goods
        XCTAssertNoThrow(
            try books.recordFinishedGoods(for: order)
        )

        // confirm changes
        XCTAssertEqual(books.finishedGoods.totalBalance(for: \.inventory),
                       49_000 + 999 * 49)
        XCTAssertEqual(books.wips.totalBalance(for: \.inventory),
                       77_777 - 999 * 49)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance,
                       77_777 - 999 * 49)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance,
                       49_000 + 999 * 49)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000)

        XCTAssert(books.rawMaterials.isEmpty)
        XCTAssert(books.clients.isEmpty)
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.equipments.isEmpty)
        XCTAssertNil(books.ledger[.revenue])
        XCTAssertNil(books.ledger[.taxesPayable])

        let wipInventory = try XCTUnwrap(books.workInProgress(forID: WorkInProgress.sample.id)?.inventory)
        XCTAssertEqual(wipInventory.qty, 1_000 - 999)
        XCTAssertEqual(wipInventory.amount, 77_777 - 999 * 49)
        XCTAssertEqual(wipInventory.balance, 77_777 - 999 * 49)

        let finishedGoodInventory = try XCTUnwrap(books.finishedGood(forID: FinishedGood.sample.id)?.inventory)
        XCTAssertEqual(finishedGoodInventory.qty, 1_000 + 999)
        XCTAssertEqual(finishedGoodInventory.amount, 49_000 + 999 * 49)
        XCTAssertEqual(finishedGoodInventory.balance, 49_000 + 999 * 49)
    }

}
