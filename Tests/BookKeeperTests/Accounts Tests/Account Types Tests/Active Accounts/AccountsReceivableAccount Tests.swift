import XCTest
import BookKeeper

extension AccountTests {
    func testAccountsReceivableAccount() {
        XCTAssertEqual(Account.init(group: .receivables).kind, .active)

        XCTAssertEqual(Account.init(group: .receivables).group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountsReceivableZero: Account = .init(group: .receivables)
        XCTAssert(accountsReceivableZero.balanceIsZero)
        XCTAssertEqual(accountsReceivableZero.group, .receivables)

        let accountsReceivableWithValue: Account = .init(
            group: .receivables,
            amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.balance, 10_000)
        XCTAssertEqual(accountsReceivableWithValue.group,
                       .receivables)
    }

    func testAccountsReceivableAccountDescription() {
        let accountsReceivableZero: Account = .init(
            group: .receivables)
        XCTAssertEqual(accountsReceivableZero.description,
                       "Accounts Receivable, active: 0.0")

        let accountsReceivableWithValue: Account = .init(
            group: .receivables,
            amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.description,
                       "Accounts Receivable, active: 10000.0")
    }

}
