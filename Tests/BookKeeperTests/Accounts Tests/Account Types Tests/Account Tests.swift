import XCTest
import BookKeeper

final class AccountTests: XCTestCase {
    enum Active: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .active
        static let group: AccountGroup = .balanceSheet(.asset(.currentAsset(.cash)))
    }

    enum Passive: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .passive
        static let group: AccountGroup = .balanceSheet(.liability(.currentLiability(.interestPayable)))
    }

    // both active passive account
    enum BothActivePassive: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .bothActivePassive
        static let group: AccountGroup = .balanceSheet(.liability(.currentLiability(.taxesPayable)))
    }

    // swiftlint:disable function_body_length
    func testAccountDebitCredit() throws {
        // active account
        var activeAccount: Account<Active> = .init()

        XCTAssertThrowsError(try activeAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<Active>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try activeAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<Active>,
                           AccountError.negativeAmount)
        }

        try activeAccount.debit(amount: 100)
        XCTAssertEqual(activeAccount.balance, 100)

        XCTAssertThrowsError(try activeAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(activeAccount))
        }

        try activeAccount.credit(amount: 50)
        XCTAssertEqual(activeAccount.balance, 50)

        // passive account
        var passiveAccount: Account<Passive> = .init()

        XCTAssertThrowsError(try passiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<Passive>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try passiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<Passive>,
                           AccountError.negativeAmount)
        }

        try passiveAccount.credit(amount: 100)
        XCTAssertEqual(passiveAccount.balance, 100)

        XCTAssertThrowsError(try passiveAccount.debit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(passiveAccount))
        }

        try passiveAccount.debit(amount: 50)
        XCTAssertEqual(passiveAccount.balance, 50)

        var bothActivePassiveAccount: Account<BothActivePassive> = .init(name: "taxes")

        XCTAssertThrowsError(try bothActivePassiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<BothActivePassive>,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError<BothActivePassive>,
                           AccountError.negativeAmount)
        }

        try bothActivePassiveAccount.debit(amount: 100)
        XCTAssertEqual(bothActivePassiveAccount.balance, 100)

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError<BothActivePassive>,
                           AccountError.insufficientBalance(bothActivePassiveAccount))
        }

        try bothActivePassiveAccount.credit(amount: 50)
        XCTAssertEqual(bothActivePassiveAccount.balance, 50)
    }
    // swiftlint:enable function_body_length

    func testDescription() {
        let active: Account<Active> = .init(name: "Active Account", amount: 99_999)
        XCTAssertEqual(active.description,
                       "Active Account(Cash (active); 99999.0)")

        let passive: Account<Passive> = .init(name: "Passive Account", amount: 88_999)
        XCTAssertEqual(passive.description,
                       "Passive Account(Interest Payable (passive); 88999.0)")
    }

}
