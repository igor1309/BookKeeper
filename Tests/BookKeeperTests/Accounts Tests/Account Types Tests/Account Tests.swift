import XCTest
import BookKeeper

final class AccountTests: XCTestCase {
    enum Active: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .active
        static let group: AccountGroup = .cash
    }

    enum Passive: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .passive
        static let group: AccountGroup = .payables
    }

    // both active passive account
    enum BothActivePassive: AccountTypeProtocol {
        static let defaultName = ""
        static let kind: AccountKind = .bothActivePassive
        static let group: AccountGroup = .taxesPayable
    }

    func testAccountDebitCreditActive() throws {
        // active account
        var activeAccount: Account = .init(group: .cash)

        XCTAssertThrowsError(try activeAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try activeAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        try activeAccount.debit(amount: 100)
        XCTAssertEqual(activeAccount.balance, 100)

        XCTAssertThrowsError(try activeAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(.cash))
        }

        try activeAccount.credit(amount: 50)
        XCTAssertEqual(activeAccount.balance, 50)
    }

    func testAccountDebitCreditPassive() throws {
        // passive account
        var passiveAccount: Account = .init(group: .taxesPayable)

        XCTAssertThrowsError(try passiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try passiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        try passiveAccount.credit(amount: 100)
        XCTAssertEqual(passiveAccount.balance, 100)

        XCTAssertThrowsError(try passiveAccount.debit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(.taxesPayable))
        }

        try passiveAccount.debit(amount: 50)
        XCTAssertEqual(passiveAccount.balance, 50)
    }

    func testAccountDebitCreditBothActivePassive() throws {
        let vatReceivable: AccountGroup = .vatReceivable
        var bothActivePassiveAccount: Account = .init(group: vatReceivable)

        XCTAssertThrowsError(try bothActivePassiveAccount.debit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: -100)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.negativeAmount)
        }

        try bothActivePassiveAccount.debit(amount: 100)
        XCTAssertEqual(bothActivePassiveAccount.balance, 100)

        XCTAssertThrowsError(try bothActivePassiveAccount.credit(amount: 200)) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(vatReceivable))
        }

        try bothActivePassiveAccount.credit(amount: 50)
        XCTAssertEqual(bothActivePassiveAccount.balance, 50)
    }

    func testDescription() {
        let active: Account = .init(
            group: .cash,
            amount: 99_999)
        XCTAssertEqual(active.description,
                       "Cash, active: 99999.0")

        let passive: Account = .init(
            group: .revenue,
            amount: 88_999)
        XCTAssertEqual(passive.description,
                       "Revenue, passive: 88999.0")
    }

}
