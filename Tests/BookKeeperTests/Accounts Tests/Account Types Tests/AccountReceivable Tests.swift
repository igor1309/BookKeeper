import XCTest
import BookKeeper

final class AccountsReceivableTests: XCTestCase {
    func testAccountsReceivableInit() {
        XCTAssertEqual(AccountsReceivable.kind, .active)

        XCTAssertEqual(AccountsReceivable.accountGroup,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountsReceivableZero: AccountsReceivable = .init()
        XCTAssertEqual(accountsReceivableZero.amount, 0)
        XCTAssertEqual(accountsReceivableZero.balance(), 0)
        XCTAssertEqual(accountsReceivableZero.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))

        let accountsReceivableWithValue: AccountsReceivable = .init(amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.amount, 10_000)
        XCTAssertEqual(accountsReceivableWithValue.balance(), 10_000)
        XCTAssertEqual(accountsReceivableWithValue.group,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))
    }

    func testDescription() {
        let accountsReceivableZero: AccountsReceivable = .init()
        XCTAssertEqual(accountsReceivableZero.description,
                       "AccountsReceivable(0.0)")
        
        let accountsReceivableWithValue: AccountsReceivable = .init(amount: 10_000)
        XCTAssertEqual(accountsReceivableWithValue.description,
                       "AccountsReceivable(10000.0)")
    }

}
