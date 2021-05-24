import XCTest
import BookKeeper

final class CashAccountTests: XCTestCase {
    func testCashAccountInit() {
        XCTAssertEqual(CashAccount.kind, .active)

        XCTAssertEqual(CashAccount.accountGroup,
                       .balanceSheet(.asset(.currentAsset(.cash))))

        let cashAccountZero: CashAccount = .init()
        XCTAssertEqual(cashAccountZero.amount, 0)
        XCTAssertEqual(cashAccountZero.balance(), 0)
        XCTAssertEqual(cashAccountZero.group,
                       .balanceSheet(.asset(.currentAsset(.cash))))

        let cashAccount: CashAccount = .init(amount: 10_000)
        XCTAssertEqual(cashAccount.amount, 10_000)
        XCTAssertEqual(cashAccount.balance(), 10_000)
        XCTAssertEqual(cashAccount.group,
                       .balanceSheet(.asset(.currentAsset(.cash))))
    }

    func testDescription() {
        let cashAccountZero: CashAccount = .init()

        XCTAssertEqual(cashAccountZero.description,
                       "CashAccount(0.0)")
        let cashAccount: CashAccount = .init(amount: 10_000)

        XCTAssertEqual(cashAccount.description,
                       "CashAccount(10000.0)")
    }

}
