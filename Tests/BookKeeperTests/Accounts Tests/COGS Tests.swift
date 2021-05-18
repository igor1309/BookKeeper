import XCTest
import BookKeeper

final class COGSTests: XCTestCase {
    func testCOGSInit() {
        XCTAssertEqual(COGS.kind, .active)

        XCTAssertEqual(COGS.accountGroup,
                       .incomeStatement(.expense(.cogs)))

        let cogsAccountZero: COGS = .init()
        XCTAssertEqual(cogsAccountZero.amount, 0)
        XCTAssertEqual(cogsAccountZero.balance(), 0)
        XCTAssertEqual(cogsAccountZero.group,
                       .incomeStatement(.expense(.cogs)))

        let cogsAccount: COGS = .init(amount: 10_000)
        XCTAssertEqual(cogsAccount.amount, 10_000)
        XCTAssertEqual(cogsAccount.balance(), 10_000)
        XCTAssertEqual(cogsAccount.group,
                       .incomeStatement(.expense(.cogs)))
    }

    func testDescription() {
        let cogsAccountZero: COGS = .init()

        XCTAssertEqual(cogsAccountZero.description,
                       "COGS(0.0)")
        let cogsAccount: COGS = .init(amount: 10_000)

        XCTAssertEqual(cogsAccount.description,
                       "COGS(10000.0)")
    }

}
