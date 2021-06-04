import XCTest
import BookKeeper

extension AccountTests {
    func testCOGSAccount() {
        XCTAssertEqual(Account.init(group: .cogs).kind, .active)

        XCTAssertEqual(Account.init(group: .cogs).group, .cogs)

        let cogsAccountZero: Account = .init(group: .cogs)
        XCTAssert(cogsAccountZero.balanceIsZero)
        XCTAssertEqual(cogsAccountZero.group, .cogs)

        let cogsAccount: Account = .init(group: .cogs, amount: 10_000)
        XCTAssertEqual(cogsAccount.balance, 10_000)
        XCTAssertEqual(cogsAccount.group, .cogs)
    }

    func testCOGSAccountDescription() {
        let cogsAccountZero: Account = .init(group: .cogs)
        XCTAssertEqual(cogsAccountZero.description,
                       "COGS, active: 0.0")

        let cogsAccount: Account = .init(group: .cogs, amount: 10_000)
        XCTAssertEqual(cogsAccount.description,
                       "COGS, active: 10000.0")
    }

}
