import XCTest
import BookKeeper

final class AccountKindTests: XCTestCase {
    func testAllCases() {
        XCTAssertEqual(AccountKind.allCases,
                       [AccountKind.active, .passive, .bothActivePassive])
    }
}
