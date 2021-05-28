import XCTest
// @testable
import BookKeeper

final class FixedAssetTests: XCTestCase {
    func testFixedAsset() {
        let fixedAsset: FixedAsset = .init(name: "Freezer",
                                           lifetime: 7,
                                           value: 7 * 12 * 9_999,
                                           vatRate: 20/100,
                                           depreciation: 200)

        XCTAssertEqual(fixedAsset.name, "Freezer")
        XCTAssertEqual(fixedAsset.value, 7 * 12 * 9_999)
        XCTAssertEqual(fixedAsset.lifetime, 7)
        XCTAssertEqual(fixedAsset.depreciation, 200)
        XCTAssertEqual(fixedAsset.carryingAmount, 7 * 12 * 9_999 - 200)
        XCTAssertEqual(fixedAsset.depreciationAmountPerMonth, 9_999)
    }
}
