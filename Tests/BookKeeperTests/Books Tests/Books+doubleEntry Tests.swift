import XCTest
import BookKeeper

struct ActiveAccount: SimpleAccount {
    var amount: Double
    static var kind: AccountKind = .active
    static var accountGroup: AccountGroup = .balanceSheet(.asset(.currentAsset(.cash)))
}

struct PassiveAccount: SimpleAccount {
    var amount: Double
    static var kind: AccountKind = .passive
    static var accountGroup: AccountGroup = .balanceSheet(.liability(.currentLiability(.accountsPayable)))
}

extension BooksTests {
    func testDoubleEntryActiveActive() throws {
        let books: Books = .init()

        var activeAccount1: ActiveAccount = .init(amount: 0)
        var activeAccount2: ActiveAccount = .init(amount: 0)
        XCTAssertEqual(activeAccount1.balance(), 0)
        XCTAssertEqual(activeAccount2.balance(), 0)

        XCTAssertThrowsError(
            try books.doubleEntry(debitAccount: &activeAccount1, creditAccount: &activeAccount2, amount: 100)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(activeAccount2))
            XCTAssertEqual(activeAccount1.balance(), 0, "Account balance should be restored")
            XCTAssertEqual(activeAccount2.balance(), 0, "Account balance should be restored")
        }

        #warning("this is a bad API - amount should not be accessible like this!!")
        activeAccount2.amount = 200
        XCTAssertNoThrow(
            try books.doubleEntry(debitAccount: &activeAccount1, creditAccount: &activeAccount2, amount: 100)
        )
        XCTAssertEqual(activeAccount1.balance(), 100)
        XCTAssertEqual(activeAccount2.balance(), 100)
    }

    func testDoubleEntryActivePassive() throws {
        let books: Books = .init()

        var activeAccount: ActiveAccount = .init(amount: 0)
        var passiveAccount: PassiveAccount = .init(amount: 0)
        XCTAssertEqual(activeAccount.balance(), 0)
        XCTAssertEqual(passiveAccount.balance(), 0)

        XCTAssertThrowsError(
            try books.doubleEntry(debitAccount: &passiveAccount, creditAccount: &activeAccount, amount: 100)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(passiveAccount))
            XCTAssertEqual(activeAccount.balance(), 0, "Account balance should be restored")
            XCTAssertEqual(passiveAccount.balance(), 0, "Account balance should be restored")
        }

        #warning("this is a bad API - amount should not be accessible like this!!")
        XCTAssertNoThrow(
            try books.doubleEntry(debitAccount: &activeAccount, creditAccount: &passiveAccount, amount: 100)
        )
        XCTAssertEqual(activeAccount.balance(), 100)
        XCTAssertEqual(passiveAccount.balance(), 100)

        XCTAssertNoThrow(
            try books.doubleEntry(debitAccount: &passiveAccount, creditAccount: &activeAccount, amount: 50)
        )
        XCTAssertEqual(activeAccount.balance(), 50)
        XCTAssertEqual(passiveAccount.balance(), 50)
    }

    func testDoubleEntryPassivePassive() throws {
        let books: Books = .init()

        var passiveAccount1: PassiveAccount = .init(amount: 0)
        var passiveAccount2: PassiveAccount = .init(amount: 0)
        XCTAssertEqual(passiveAccount1.balance(), 0)
        XCTAssertEqual(passiveAccount2.balance(), 0)

        XCTAssertThrowsError(
            try books.doubleEntry(debitAccount: &passiveAccount1, creditAccount: &passiveAccount2, amount: 100)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(passiveAccount1))
            XCTAssertEqual(passiveAccount1.balance(), 0, "Account balance should be restored")
            XCTAssertEqual(passiveAccount2.balance(), 0, "Account balance should be restored")
        }

        #warning("this is a bad API - amount should not be accessible like this!!")
        passiveAccount1.amount = 200
        XCTAssertNoThrow(
            try books.doubleEntry(debitAccount: &passiveAccount1, creditAccount: &passiveAccount2, amount: 100)
        )
        XCTAssertEqual(passiveAccount1.balance(), 100)
        XCTAssertEqual(passiveAccount2.balance(), 100)
    }

}

