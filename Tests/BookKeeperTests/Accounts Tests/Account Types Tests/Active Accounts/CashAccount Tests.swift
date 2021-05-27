import XCTest
import BookKeeper

extension AccountTests {
    func testCashAccount() {
        XCTAssertEqual(Account<Cash>.init().kind, .active)

        XCTAssertEqual(Account<Cash>.init().group,
                       .balanceSheet(.asset(.currentAsset(.cash))))

        let cashAccountZero: Account<Cash> = .init()
        XCTAssertEqual(cashAccountZero.balance(), 0)
        XCTAssertEqual(cashAccountZero.group,
                       .balanceSheet(.asset(.currentAsset(.cash))))

        let cashAccount: Account<Cash> = .init(amount: 10_000)
        XCTAssertEqual(cashAccount.balance(), 10_000)
        XCTAssertEqual(cashAccount.group,
                       .balanceSheet(.asset(.currentAsset(.cash))))
    }

    func testCashAccountDescription() {
        let cashAccountZero: Account<Cash> = .init()
        XCTAssertEqual(cashAccountZero.description,
                       "Cash(Cash (active); 0.0)")

        let cashAccount: Account<Cash> = .init(amount: 10_000)
        XCTAssertEqual(cashAccount.description,
                       "Cash(Cash (active); 10000.0)")
    }

}
