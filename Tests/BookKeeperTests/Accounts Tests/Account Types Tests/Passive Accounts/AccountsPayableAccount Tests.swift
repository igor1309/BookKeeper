import XCTest
// @testable
import BookKeeper

extension AccountTests {
    func testAccountsPayableAccount() {
        XCTAssertEqual(Account<AccountsPayable>.init().kind,
                       .passive)

        XCTAssertEqual(Account<AccountsPayable>.init().group,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))

        let accountsPayableZero: Account<AccountsPayable> = .init()
        XCTAssertEqual(accountsPayableZero.balance(), 0)
        XCTAssertEqual(accountsPayableZero.group,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))

        let accountsPayableWithValue: Account<AccountsPayable> = .init(amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.balance(), 10_000)
        XCTAssertEqual(accountsPayableWithValue.group,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))
    }

    func testAccountsPayableAccountDescription() {
        let accountsPayableZero: Account<AccountsPayable> = .init()
        XCTAssertEqual(accountsPayableZero.description,
                       "Accounts Payable(Accounts Payable (passive); 0.0)")

        let accountsPayableWithValue: Account<AccountsPayable> = .init(amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.description,
                       "Accounts Payable(Accounts Payable (passive); 10000.0)")
    }

}

