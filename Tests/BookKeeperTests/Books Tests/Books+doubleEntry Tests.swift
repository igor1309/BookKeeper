import XCTest
@testable import BookKeeper

extension BooksTests {
    func testDoubleEntryActiveActiveInsufficientBalanceError() throws {
        // books with no overwrite
        let active1: AccountGroup = .cash
        let active2: AccountGroup = .vatReceivable
        var books: Books = .init(
            ledger: [.init(group: active1, amount: 10),
                     .init(group: active2, amount: 10)]
        )
        // confirm balances
        XCTAssertEqual(books.ledger[active1]?.balance, 10)
        XCTAssertEqual(books.ledger[active2]?.balance, 10)

        // try double entry
        XCTAssertThrowsError(
            try books.doubleEntry(debit: active1, credit: active2, amount: 100)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(active2))
        }

        // confirm no change after error
        XCTAssertEqual(books.ledger[active1]?.balance, 10,
                       "Account balance should be restored")
        XCTAssertEqual(books.ledger[active2]?.balance, 10,
                       "Account balance should be restored")
    }

    func testDoubleEntryActiveActiveNegativeAmountError() throws {
        // books with no overwrite
        let active1: AccountGroup = .cash
        let active2: AccountGroup = .vatReceivable
        var books: Books = .init(
            ledger: [.init(group: active1, amount: 100),
                     .init(group: active2, amount: 100)]
        )

        // confirm balances
        XCTAssertEqual(books.ledger[active1]?.balance, 100)
        XCTAssertEqual(books.ledger[active2]?.balance, 100)

        // try double entry
        XCTAssertThrowsError(
            try books.doubleEntry(debit: active1, credit: active2, amount: -100)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        // confirm no change after error
        XCTAssertEqual(books.ledger[active1]?.balance, 100)
        XCTAssertEqual(books.ledger[active2]?.balance, 100)
    }

    func testDoubleEntryActiveActiveNoErrors() throws {
        // books with no overwrite
        let active1: AccountGroup = .cash
        let active2: AccountGroup = .vatReceivable
        var books: Books = .init(
            ledger: [.init(group: active1, amount: 100),
                     .init(group: active2, amount: 100)]
        )

        // confirm balances
        XCTAssertEqual(books.ledger[active1]?.balance, 100)
        XCTAssertEqual(books.ledger[active2]?.balance, 100)

        // try double entry
        XCTAssertNoThrow(
            try books.doubleEntry(debit: active1, credit: active2, amount: 100)
        )

        // confirm
        XCTAssertEqual(books.ledger[active1]?.balance, 200)
        XCTAssertEqual(books.ledger[active2]?.balance, 0)
    }

    func testDoubleEntryActivePassiveInsufficientBalanceError() {
        // ledger with active and passive accounts
        let active: AccountGroup = .cash
        let passive: AccountGroup = .loan
        var books: Books = .init(
            ledger: [.init(group: active, amount: 100),
                     .init(group: passive, amount: 50)])

        // confirm balances
        XCTAssertEqual(books.ledger[active]?.balance, 100)
        XCTAssertEqual(books.ledger[passive]?.balance, 50)

        // try decrease zero balances
        XCTAssertThrowsError(
            try books.doubleEntry(debit: passive, credit: active, amount: 200)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(passive))
        }

        // confirm no change after error
        XCTAssertEqual(books.ledger[active]?.balance, 100)
        XCTAssertEqual(books.ledger[passive]?.balance, 50)
    }

    func testDoubleEntryActivePassiveNoErrors() throws {
        // ledger with active and passive accounts
        let active: AccountGroup = .cash
        let passive: AccountGroup = .loan
        var books: Books = .init(
            ledger: [.init(group: active, amount: 100),
                     .init(group: passive, amount: 50)])

        // confirm balances
        XCTAssertEqual(books.ledger[active]?.balance, 100)
        XCTAssertEqual(books.ledger[passive]?.balance, 50)

        // try double entry
        XCTAssertNoThrow(
            try books.doubleEntry(debit: active, credit: passive, amount: 100)
        )

        // confirm balances changed
        XCTAssertEqual(books.ledger[active]?.balance, 200)
        XCTAssertEqual(books.ledger[passive]?.balance, 150)

        // try opposite double entry
        XCTAssertNoThrow(
            try books.doubleEntry(debit: passive, credit: active, amount: 50)
        )
        XCTAssertEqual(books.ledger[active]?.balance, 150)
        XCTAssertEqual(books.ledger[passive]?.balance, 100)
    }

    func testDoubleEntryPassivePassiveInsufficientBalanceError() {
        // ledger with two passive accounts
        let passive1: AccountGroup = .balanceSheet(.liability(.currentLiability(.interestPayable)))
        let passive2: AccountGroup = .loan
        var books: Books = .init(
            ledger: [.init(group: passive1, amount: 200),
                     .init(group: passive2, amount: 50)])

        // confirm balances
        XCTAssertEqual(books.ledger[passive1]?.balance, 200)
        XCTAssertEqual(books.ledger[passive2]?.balance, 50)

        // try double entry
        XCTAssertThrowsError(
            try books.doubleEntry(debit: passive1, credit: passive2, amount: 500)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(passive1))
        }

        // confirm no change after error
        XCTAssertEqual(books.ledger[passive1]?.balance, 200)
        XCTAssertEqual(books.ledger[passive2]?.balance, 50)
    }

    func testDoubleEntryPassivePassiveNoErrors() {
        // ledger with two passive accounts
        let passive1: AccountGroup = .balanceSheet(.liability(.currentLiability(.interestPayable)))
        let passive2: AccountGroup = .loan
        var books: Books = .init(
            ledger: [.init(group: passive1, amount: 200),
                     .init(group: passive2, amount: 50)])

        // confirm balances
        XCTAssertEqual(books.ledger[passive1]?.balance, 200)
        XCTAssertEqual(books.ledger[passive2]?.balance, 50)

        // try double entry
        XCTAssertNoThrow(
            try books.doubleEntry(debit: passive1, credit: passive2, amount: 100)
        )
        XCTAssertEqual(books.ledger[passive1]?.balance, 100)
        XCTAssertEqual(books.ledger[passive2]?.balance, 150)
    }

}

