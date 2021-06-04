import XCTest
import BookKeeper

extension AccountTests {
    func testRevenueAccount() {
        XCTAssertEqual(Account.init(group: .revenue).kind, .passive)

        XCTAssertEqual(Account.init(group: .revenue).group, .revenue)

        let revenueAccount0: Account = .init(group: .revenue)
        XCTAssert(revenueAccount0.balanceIsZero)
        XCTAssertEqual(revenueAccount0.group, .revenue)

        let revenueAccount1: Account = .init(group: .revenue, amount: 1_000)
        XCTAssertEqual(revenueAccount1.balance, 1_000)
        XCTAssertEqual(revenueAccount1.group, .revenue)
    }

    func testRevenueAccountDescription() {
        XCTAssertEqual(Account.init(group: .revenue).description,
                       "Revenue, passive: 0.0")
        XCTAssertEqual(Account.init(group: .revenue, amount: 10_000).description,
                       "Revenue, passive: 10000.0")
    }

}
