import XCTest
import BookKeeper

final class SimpleAccountTests: XCTestCase {
    struct ActiveAccount: SimpleAccount {
        var amount: Double = 0
        static var kind: AccountKind = .active
        static var accountGroup: AccountGroup = .balanceSheet(.asset(.currentAsset(.cash)))
    }

    struct PassiveAccount: SimpleAccount {
        var amount: Double = 0
        static var kind: AccountKind = .passive
        static var accountGroup: AccountGroup = .balanceSheet(.liability(.currentLiability(.accountsPayable)))
    }

    struct BothActivePassiveAccount: SimpleAccount {
        var amount: Double = 0
        static var kind: AccountKind = .bothActivePassive
        static var accountGroup: AccountGroup = .balanceSheet(.equity(.retainedEarnings))
    }

    func testDebitCreditSimpleAccountDefaultImplementation() throws {
        // active account
        var activeAccount: ActiveAccount = .init()

        XCTAssertThrowsError(try activeAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<ActiveAccount>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try activeAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<ActiveAccount>,
                           AccountError.negativeAmount)
        }

        try activeAccount.debit(amount: 100)
        XCTAssertEqual(activeAccount.balance(), 100)

        XCTAssertThrowsError(try activeAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as! AccountError<ActiveAccount>,
                           AccountError.insufficientBalance(activeAccount))
        }

        try activeAccount.credit(amount: 50)
        XCTAssertEqual(activeAccount.balance(), 50)

        // passive account
        var passiveAccount: PassiveAccount = .init()

        XCTAssertThrowsError(try passiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<PassiveAccount>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try passiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<PassiveAccount>,
                           AccountError.negativeAmount)
        }

        try passiveAccount.credit(amount: 100)
        XCTAssertEqual(passiveAccount.balance(), 100)

        XCTAssertThrowsError(try passiveAccount.debit(amount: 200)) { error in
            XCTAssertEqual(error as! AccountError<PassiveAccount>,
                           AccountError.insufficientBalance(passiveAccount))
        }

        try passiveAccount.debit(amount: 50)
        XCTAssertEqual(passiveAccount.balance(), 50)

        // both active passive account
        var bothActivePassiveAccount: BothActivePassiveAccount = .init()

        XCTAssertThrowsError(try bothActivePassiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<BothActivePassiveAccount>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as! AccountError<BothActivePassiveAccount>,
                           AccountError.negativeAmount)
        }

        try bothActivePassiveAccount.debit(amount: 100)
        XCTAssertEqual(bothActivePassiveAccount.balance(), 100)

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as! AccountError<BothActivePassiveAccount>,
                           AccountError.insufficientBalance(bothActivePassiveAccount))
        }

        try bothActivePassiveAccount.credit(amount: 50)
        XCTAssertEqual(bothActivePassiveAccount.balance(), 50)

    }
}
