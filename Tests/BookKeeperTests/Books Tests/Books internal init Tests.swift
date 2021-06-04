/*
 import XCTest
@testable import BookKeeper

extension BooksTests {
    func testInternalInitWithParameters() {
        // initiate books
        let rawMaterial: RawMaterial = .sample
        let rawMaterials: [RawMaterial.ID: RawMaterial] = [rawMaterial.id: rawMaterial]

        let workInProgress: WorkInProgress = .sample
        let wips: [WorkInProgress.ID: WorkInProgress] = [workInProgress.id: workInProgress]

        let finishedGood: FinishedGood = .sample
        let finishedGoods: [FinishedGood.ID: FinishedGood] = [finishedGood.id: finishedGood]

        let client: Client = .sample
        let clients: [Client.ID: Client] = [client.id: client]

        let supplier: Supplier = .sample
        let suppliers: [Supplier.ID: Supplier] = [supplier.id: supplier]

        let equipment: Equipment = .sample
        let equipments: [Equipment.ID: Equipment] = [equipment.id: equipment]

        let ledger: [AccountGroup: Account] = [
            .rawInventory: .init(group: .rawInventory, amount: 333),
            .wipsInventory: .init(group: .wipsInventory, amount: 333),
            .finishedInventory: .init(group: .finishedInventory, amount: 333),
            .equipment: .init(group: .equipment, amount: 333),
            .receivables: .init(group: .receivables, amount: 333),
            .payables: .init(group: .payables, amount: 333),
            .accumulatedDepreciation: .init(group: .accumulatedDepreciation, amount: 333),
            .cogs: .init(group: .cogs, amount: 333),
            .depreciationExpenses: .init(group: .depreciationExpenses, amount: 333)
        ]

        // initiate books with internal init (see @testable in import)
        let books: Books = .init(rawMaterials: rawMaterials,
                                 wips: wips,
                                 finishedGoods: finishedGoods,
                                 clients: clients,
                                 suppliers: suppliers,
                                 equipments: equipments,
                                 ledger: ledger
        )

        // confirm
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.first?.value, RawMaterial.sample)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 37_555,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.first?.value, WorkInProgress.sample)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 77_777,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.first?.value, FinishedGood.sample)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 49_000,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.cogs]?.balance, 35_000,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.first?.value, Client.sample)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 66_666,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value, Supplier.sample)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(books.equipments.count, 1)
        XCTAssertEqual(books.equipments.first?.value, Equipment.sample)
        XCTAssertEqual(books.ledger[.equipment]?.balance, 999_999,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.accumulatedDepreciation]?.balance, 47_619,
                       "Account balance from parameter ledger should be overwritten.")
        XCTAssertEqual(books.ledger[.depreciationExpenses]?.balance, 47_619,
                       "Account balance from parameter ledger should be overwritten.")

        XCTAssertEqual(ledger.count, 9)
        XCTAssertEqual(books.ledger.count, 9)

        XCTAssertNil(books.ledger[.cash], "Account should not be created")
        XCTAssertNil(books.ledger[.revenue], "Account should not be created")
        XCTAssertNil(books.ledger[.vatReceivable], "Account should not be created")
        XCTAssertNil(books.ledger[.taxesPayable], "Account should not be created")
    }

}
*/
