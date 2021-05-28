import XCTest
import BookKeeper

final class AccountKindTests: XCTestCase {
    func testAllCases() {
        XCTAssertEqual(AccountKind.allCases,
                       [AccountKind.active, .passive, .bothActivePassive])
    }

    func testRawValue() {
        XCTAssertEqual(AccountKind.active.rawValue, "Active")
        XCTAssertEqual(AccountKind.passive.rawValue, "Passive")
        XCTAssertEqual(AccountKind.bothActivePassive.rawValue, "Both Active Passive")
    }

    func testString() {
        XCTAssertEqual("\(AccountKind.active)", "active")
        XCTAssertEqual("\(AccountKind.passive)", "passive")
        XCTAssertEqual("\(AccountKind.bothActivePassive)", "bothActivePassive")
    }

}
