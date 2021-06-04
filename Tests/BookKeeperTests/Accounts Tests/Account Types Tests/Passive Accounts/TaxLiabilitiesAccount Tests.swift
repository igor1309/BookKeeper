import XCTest
import BookKeeper

extension AccountTests {
    func testTaxLiabilitiesAccount() {
        XCTAssertEqual(Account.init(group: .taxesPayable).kind,
                       .passive)

        XCTAssertEqual(Account.init(group: .taxesPayable).group,
                       AccountGroup.taxesPayable)

        let taxLiabilities0: Account = .init(group: .taxesPayable)
        XCTAssert(taxLiabilities0.balanceIsZero)
        XCTAssertEqual(taxLiabilities0.group,
                       AccountGroup.taxesPayable)

        let taxLiabilities1: Account = .init(group: .taxesPayable, amount: 1_000)
        XCTAssertEqual(taxLiabilities1.balance, 1_000)
        XCTAssertEqual(taxLiabilities1.group,
                       AccountGroup.taxesPayable)
    }

    func testTaxLiabilitiesAccountDescription() {
        let taxLiabilitiesZero: Account = .init(group: .taxesPayable)
        XCTAssertEqual(taxLiabilitiesZero.description,
                       "Taxes Payable, passive: 0.0")

        let taxLiabilities: Account = .init(group: .taxesPayable, amount: 10_000)
        XCTAssertEqual(taxLiabilities.description,
                       "Taxes Payable, passive: 10000.0")
    }

}
