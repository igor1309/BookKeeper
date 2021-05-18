import XCTest
import BookKeeper

final class TaxLiabilitiesTests: XCTestCase {
    func testTaxLiabilitiesInit() {
        XCTAssertEqual(TaxLiabilities.kind, .passive)

        XCTAssertEqual(TaxLiabilities.accountGroup,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))

        let taxLiabilities0: TaxLiabilities = .init()
        XCTAssertEqual(taxLiabilities0.amount, 0)
        XCTAssertEqual(taxLiabilities0.balance(), 0)
        XCTAssertEqual(taxLiabilities0.group,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))

        let taxLiabilities1: TaxLiabilities = .init(amount: 1_000)
        XCTAssertEqual(taxLiabilities1.amount, 1_000)
        XCTAssertEqual(taxLiabilities1.balance(), 1_000)
        XCTAssertEqual(taxLiabilities1.group,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))
    }

    func testDescription() {
        XCTAssertEqual(TaxLiabilities().description,
                       "TaxLiabilities(0.0)")
        XCTAssertEqual(TaxLiabilities(amount: 10_000).description,
                       "TaxLiabilities(10000.0)")
    }

}
