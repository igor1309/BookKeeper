import XCTest
import BookKeeper

final class AccountKindTests: XCTestCase {
    func testAllCases() {
        XCTAssertEqual(AccountKind.allCases,
                       [AccountKind.active, .passive, .bothActivePassive])
    }

    #warning("more tests here ?")
    
    func testString() {
        XCTAssertEqual("\(AccountKind.active)", "active")
        XCTAssertEqual("\(AccountKind.passive)", "passive")
        XCTAssertEqual("\(AccountKind.bothActivePassive)", "bothActivePassive")
    }

}
