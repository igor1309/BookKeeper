import XCTest
import BookKeeper

extension AccountGroupTests {
    func testStatic() {
        XCTAssertEqual(AccountGroup.cash,
                       .balanceSheet(.asset(.currentAsset(.cash))))
        XCTAssertEqual(AccountGroup.receivables,
                       .balanceSheet(.asset(.currentAsset(.accountsReceivable))))
        XCTAssertEqual(AccountGroup.vatReceivable,
                       .balanceSheet(.asset(.currentAsset(.vatReceivable))))

        XCTAssertEqual(AccountGroup.equipment,
                       .balanceSheet(.asset(.propertyPlantEquipment(.equipment))))
        XCTAssertEqual(AccountGroup.accumulatedDepreciation,
                       .balanceSheet(.asset(.propertyPlantEquipment(.accumulatedDepreciationEquipment))))
        XCTAssertEqual(AccountGroup.payables,
                       .balanceSheet(.liability(.currentLiability(.accountsPayable))))
        XCTAssertEqual(AccountGroup.taxesPayable,
                       .balanceSheet(.liability(.currentLiability(.taxesPayable))))

        XCTAssertEqual(AccountGroup.revenue,
                       .incomeStatement(.revenue))
        XCTAssertEqual(AccountGroup.cogs,
                       .incomeStatement(.expense(.cogs)))
        XCTAssertEqual(AccountGroup.depreciationExpenses,
                       .incomeStatement(.expense(.depreciation)))

        XCTAssertEqual(AccountGroup.rawInventory,
                       .balanceSheet(.asset(.currentAsset(.inventory(.rawMaterials)))))
        XCTAssertEqual(AccountGroup.wipsInventory,
                       .balanceSheet(.asset(.currentAsset(.inventory(.workInProgress)))))
        XCTAssertEqual(AccountGroup.finishedInventory,
                       .balanceSheet(.asset(.currentAsset(.inventory(.finishedGoods)))))

    }

}
