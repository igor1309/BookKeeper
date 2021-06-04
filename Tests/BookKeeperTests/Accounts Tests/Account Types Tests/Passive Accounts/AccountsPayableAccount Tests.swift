import XCTest
import BookKeeper

extension AccountTests {
    func testAccountsPayableAccount() {
        XCTAssertEqual(Account.init(group: .payables).kind,
                       .passive)

        XCTAssertEqual(Account.init(group: .payables).group,
                       AccountGroup.payables)

        let accountsPayableZero: Account = .init(group: .payables)
        XCTAssert(accountsPayableZero.balanceIsZero)
        XCTAssertEqual(accountsPayableZero.group,
                       AccountGroup.payables)

        let accountsPayableWithValue: Account = .init(group: .payables, amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.balance, 10_000)
        XCTAssertEqual(accountsPayableWithValue.group,
                       AccountGroup.payables)
    }

    func testAccountsPayableAccountDescription() {
        let accountsPayableZero: Account = .init(group: .payables)
        XCTAssertEqual(accountsPayableZero.description,
                       "Accounts Payable, passive: 0.0")

        let accountsPayableWithValue: Account = .init(group: .payables, amount: 10_000)
        XCTAssertEqual(accountsPayableWithValue.description,
                       "Accounts Payable, passive: 10000.0")
    }

}
