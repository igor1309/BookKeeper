import XCTest
import BookKeeper

final class AccountReceivableTests: XCTestCase {
    func testAccountReceivableInit() {
        XCTAssertEqual(AccountReceivable.kind, .active)

        XCTAssertEqual(AccountReceivable.accountGroup,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountReceivableZero: AccountReceivable = .init()
        XCTAssertEqual(accountReceivableZero.amount, 0)
        XCTAssertEqual(accountReceivableZero.balance(), 0)
        XCTAssertEqual(accountReceivableZero.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountReceivableWithValue: AccountReceivable = .init(amount: 10_000)
        XCTAssertEqual(accountReceivableWithValue.amount, 10_000)
        XCTAssertEqual(accountReceivableWithValue.balance(), 10_000)
        XCTAssertEqual(accountReceivableWithValue.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))
    }

    func testDescription() {
        let accountReceivableZero: AccountReceivable = .init()
        XCTAssertEqual(accountReceivableZero.description,
                       "AccountReceivable(0.0)")
        
        let accountReceivableWithValue: AccountReceivable = .init(amount: 10_000)
        XCTAssertEqual(accountReceivableWithValue.description,
                       "AccountReceivable(10000.0)")
    }

}
