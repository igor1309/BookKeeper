import XCTest
import BookKeeper

final class AccountGroupTests: XCTestCase {
    var accountsReceivable: Account<AccountsReceivable>!
    var cogsAccount: Account<COGS>!
    var inventoryAccount: InventoryAccount!
    var revenueAccount: RevenueAccount!
    var taxLiabilities: Account<TaxLiabilities>!

    override func setUpWithError() throws {
        accountsReceivable = .init(amount: 10_000)
        cogsAccount = .init(amount: 10_000)
        inventoryAccount = .init(qty: 1_000, amount: 59_000)
        revenueAccount = .init(amount: 20_000)
        taxLiabilities = .init(amount: 5_000)
    }

    func testAccountGroup() {
        XCTFail()
    }

    func testBalanceSheet() {
        XCTFail()
    }

    func testAsset() {
        XCTFail()
    }

    func testCurrentAsset() {
        XCTFail()
    }

    func testPropertyPlantEquipment() {
        XCTFail()
    }

    func testLiability() {
        XCTFail()
    }
    
    func testCurrentLiability() {
        XCTFail()
    }

    func testLongtermLiability() {
        XCTFail()
    }

    func testEquity() {
        XCTFail()
    }

    func testIncomeStatement() {
        XCTFail()
    }

    func testExpense() {
        XCTFail()
    }

    func testBalance() {
        XCTFail("finish with this test")
        //        let accounts: [Any] = [accountsReceivable,
        //                                        cogs,
        //                                        inventory,
        //                                        revenue,
        //                                        taxes]
        //
        //        let assets = accounts.filter { $0.group.isAsset }
        //            .reduce(0, { $0 + $1.balance() })
        //        XCTAssertEqual(assets, 20_000 + 100_000)
        //
        //        let liabilities = accounts.filter { $0.group.isLiability }
        //            .reduce(0, { $0 + $1.balance() })
        //        XCTAssertEqual(liabilities, 5_000)
        //
        //        let equity = accounts.filter { $0.group.isEquity }
        //            .reduce(0, { $0 + $1.balance() })
        //        XCTAssertEqual(equity, 0)
    }
}

