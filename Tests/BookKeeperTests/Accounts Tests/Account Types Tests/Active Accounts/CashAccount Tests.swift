import XCTest
import BookKeeper

extension AccountTests {
    func testCashAccount() {
        XCTAssertEqual(Account.init(group: .cash).kind, .active)

        XCTAssertEqual(Account.init(group: .cash).group, .cash)

        let cashAccountZero: Account = .init(group: .cash)
        XCTAssert(cashAccountZero.balanceIsZero)
        XCTAssertEqual(cashAccountZero.group, .cash)

        let cashAccount: Account = .init(group: .cash, amount: 10_000)
        XCTAssertEqual(cashAccount.balance, 10_000)
        XCTAssertEqual(cashAccount.group, .cash)
    }

    func testCashAccountDescription() {
        let cashAccountZero: Account = .init(group: .cash)
        XCTAssertEqual(cashAccountZero.description,
                       "Cash, active: 0.0")

        let cashAccount: Account = .init(group: .cash, amount: 10_000)
        XCTAssertEqual(cashAccount.description,
                       "Cash, active: 10000.0")
    }

}
