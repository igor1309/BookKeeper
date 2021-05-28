import XCTest
import BookKeeper

extension AccountTests {
    func testTaxLiabilitiesAccount() {
        XCTAssertEqual(Account<TaxLiabilities>.init().kind,
                       .passive)

        XCTAssertEqual(Account<TaxLiabilities>.init().group,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))

        let taxLiabilities0: Account<TaxLiabilities> = .init()
        XCTAssert(taxLiabilities0.balanceIsZero)
        XCTAssertEqual(taxLiabilities0.group,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))

        let taxLiabilities1: Account<TaxLiabilities> = .init(amount: 1_000)
        XCTAssertEqual(taxLiabilities1.balance, 1_000)
        XCTAssertEqual(taxLiabilities1.group,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))
    }

    func testTaxLiabilitiesAccountDescription() {
        let taxLiabilitiesZero: Account<TaxLiabilities> = .init()
        XCTAssertEqual(taxLiabilitiesZero.description,
                       "Tax Liabilities(Taxes Payable (passive); 0.0)")

        let taxLiabilities: Account<TaxLiabilities> = .init(amount: 10_000)
        XCTAssertEqual(taxLiabilities.description,
                       "Tax Liabilities(Taxes Payable (passive); 10000.0)")
    }

}
