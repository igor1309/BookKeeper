import XCTest
import BookKeeper

extension AccountTests {
    func testRevenueAccount() {
        XCTAssertEqual(Account<Revenue>.init().kind, .passive)

        XCTAssertEqual(Account<Revenue>.init().group,
                       .incomeStatement(.revenue))

        let revenueAccount0: Account<Revenue> = .init()
        XCTAssert(revenueAccount0.balanceIsZero)
        XCTAssertEqual(revenueAccount0.group,
                       .incomeStatement(.revenue))

        let revenueAccount1: Account<Revenue> = .init(amount: 1_000)
        XCTAssertEqual(revenueAccount1.balance, 1_000)
        XCTAssertEqual(revenueAccount1.group,
                       .incomeStatement(.revenue))
    }

    func testRevenueAccountDescription() {
        XCTAssertEqual(Account<Revenue>.init().description,
                       "Revenue(Revenue (passive); 0.0)")
        XCTAssertEqual(Account<Revenue>.init(amount: 10_000).description,
                       "Revenue(Revenue (passive); 10000.0)")
    }

}
