import XCTest
@testable import BookKeeper

// MARK: Business Operations

extension BooksTests {
    func testDepreciateEquipmentDepreciationFailsError() throws {
        // open books with equipment
        let equipment: Equipment = .sample
        var books: Books = .init(equipments: equipment)

        // depreciate a lot
        for _ in 1...80 {
            try books.depreciateEquipment()
        }

        // confirm changes
        XCTAssertEqual(books.equipments.sum(for: \.initialValue), 999_999)
        XCTAssertEqual(books.equipments.sum(for: \.depreciation), 47_619 + 80 * 11_904.75)
        XCTAssertEqual(books.equipments.sum(for: \.carryingAmount), 0)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999)
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619 + 80 * 11_904.75)
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619 + 80 * 11_904.75)

        XCTAssertThrowsError(
            try books.depreciateEquipment()
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.depreciationFail)
        }

        // confirm no change after error
        XCTAssertEqual(books.equipments.sum(for: \.initialValue), 999_999)
        XCTAssertEqual(books.equipments.sum(for: \.depreciation), 47_619 + 80 * 11_904.75)
        XCTAssertEqual(books.equipments.sum(for: \.carryingAmount), 0)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999)
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619 + 80 * 11_904.75)
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619 + 80 * 11_904.75)
    }

    func testDepreciateEquipmentNoErrors() throws {
        // open books with equipment
        let equipment: Equipment = .sample
        var books: Books = .init(equipments: equipment)

        // confirm
        XCTAssertEqual(Array(books.equipments.values), [equipment])
        XCTAssertEqual(books.equipments.sum(for: \.initialValue), 999_999)
        XCTAssertEqual(books.equipments.sum(for: \.depreciation), 47_619)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999)
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619)
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619)

        // try depreciate equipment
        XCTAssertNoThrow(try books.depreciateEquipment())

        // confirm changes
        XCTAssertEqual(books.equipments.sum(for: \.initialValue), 999_999)
        XCTAssertEqual(books.equipments.sum(for: \.depreciation), 47_619 + 11_904.75)

        XCTAssertEqual(books.ledger.count, 3)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999)
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619 + 11_904.75)
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619 + 11_904.75)
    }

}
