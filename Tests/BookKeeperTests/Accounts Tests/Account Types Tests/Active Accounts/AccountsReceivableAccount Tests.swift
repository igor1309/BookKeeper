import XCTest
import BookKeeper

extension AccountTests {
    func testAccountsReceivableAccount() {
        XCTAssertEqual(Account<AccountsReceivable>.init().kind, .active)

        XCTAssertEqual(Account<AccountsReceivable>.init().group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountsReceivableZero: Account<AccountsReceivable> = .init()
        XCTAssert(accountsReceivableZero.balanceIsZero)
        XCTAssertEqual(accountsReceivableZero.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountsReceivableWithValue: Account<AccountsReceivable> = .init(amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.balance, 10_000)
        XCTAssertEqual(accountsReceivableWithValue.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))
    }

    func testAccountsReceivableAccountDescription() {
        let accountsReceivableZero: Account<AccountsReceivable> = .init()
        XCTAssertEqual(accountsReceivableZero.description,
                       "Accounts Receivable(Accounts Receivable (active); 0.0)")

        let accountsReceivableWithValue: Account<AccountsReceivable> = .init(amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.description,
                       "Accounts Receivable(Accounts Receivable (active); 10000.0)")
    }

}
