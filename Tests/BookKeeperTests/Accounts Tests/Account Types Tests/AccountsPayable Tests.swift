import XCTest
// @testable
import BookKeeper

final class AccountsPayableTests: XCTestCase {
    func testAccountsPayableInit() {
        XCTAssertEqual(AccountsPayable.kind, .passive)

        XCTAssertEqual(AccountsPayable.accountGroup,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))

        let accountsPayableZero: AccountsPayable = .init()
        XCTAssertEqual(accountsPayableZero.amount, 0)
        XCTAssertEqual(accountsPayableZero.balance(), 0)
        XCTAssertEqual(accountsPayableZero.group,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))

        let accountsPayableWithValue: AccountsPayable = .init(amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.amount, 10_000)
        XCTAssertEqual(accountsPayableWithValue.balance(), 10_000)
        XCTAssertEqual(accountsPayableWithValue.group,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))
    }

    func testDescription() {
        let accountsPayableZero: AccountsPayable = .init()
        XCTAssertEqual(accountsPayableZero.description,
                       "AccountsPayable(0.0)")

        let accountsPayableWithValue: AccountsPayable = .init(amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.description,
                       "AccountsPayable(10000.0)")
    }

}

