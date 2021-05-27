import XCTest
import BookKeeper

extension AccountTests {
    func testCOGSAccount() {
        XCTAssertEqual(Account<COGS>.init().kind, .active)

        XCTAssertEqual(Account<COGS>.init().group,
                       .incomeStatement(.expense(.cogs)))

        let cogsAccountZero: Account<COGS> = .init()
        XCTAssertEqual(cogsAccountZero.balance(), 0)
        XCTAssertEqual(cogsAccountZero.group,
                       .incomeStatement(.expense(.cogs)))

        let cogsAccount: Account<COGS> = .init(amount: 10_000)
        XCTAssertEqual(cogsAccount.balance(), 10_000)
        XCTAssertEqual(cogsAccount.group,
                       .incomeStatement(.expense(.cogs)))
    }

    func testCOGSAccountDescription() {
        let cogsAccountZero: Account<COGS> = .init()
        XCTAssertEqual(cogsAccountZero.description,
                       "COGS(COGS (active); 0.0)")

        let cogsAccount: Account<COGS> = .init(amount: 10_000)
        XCTAssertEqual(cogsAccount.description,
                       "COGS(COGS (active); 10000.0)")
    }

}
