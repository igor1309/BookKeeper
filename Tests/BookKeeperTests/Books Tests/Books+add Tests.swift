import XCTest
// @testable
import BookKeeper

// MARK: - Add
extension BooksTests {
    func testAddClient() {
        let client: Client = .sample
        var books: Books = .init()
        XCTAssert(books.clients.isEmpty)

        books.add(client: client)
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients, [client.id: client])
        XCTAssertEqual(books.client(forID: client.id), client)

        books.add(client: client)
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients, [client.id: client],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.client(forID: client.id), client,
                       "Adding element with the same id should not duplicate.")

        let client2: Client = .init(name: "Client2")
        books.add(client: client2)
        XCTAssertEqual(books.clients.count, 2)
        XCTAssertEqual(books.client(forID: client2.id), client2)
    }

    func testAddSupplier() {
        let supplier: Supplier = .sample
        var books: Books = .init()
        XCTAssert(books.suppliers.isEmpty)

        books.add(supplier: supplier)
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers, [supplier.id: supplier])
        XCTAssertEqual(books.supplier(forID: supplier.id), supplier)

        books.add(supplier: supplier)
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers, [supplier.id: supplier],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.supplier(forID: supplier.id), supplier,
                       "Adding element with the same id should not duplicate.")

        let supplier2: Supplier = .init(name: "Supplier2")
        books.add(supplier: supplier2)
        XCTAssertEqual(books.suppliers.count, 2)
        XCTAssertEqual(books.supplier(forID: supplier2.id), supplier2)
    }

    func testAddFinishedGood() {
        let finishedGood: FinishedGood = .sample
        var books: Books = .init()
        XCTAssert(books.finishedGoods.isEmpty)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods, [finishedGood.id: finishedGood])
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods, [finishedGood.id: finishedGood],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood,
                       "Adding element with the same id should not duplicate.")

        let finishedGood2: FinishedGood = .init(name: "Client2")
        books.add(finishedGood: finishedGood2)
        XCTAssertEqual(books.finishedGoods.count, 2)
        XCTAssertEqual(books.finishedGood(forID: finishedGood2.id), finishedGood2)
    }

    func testAddWorkInProgress() {
        let workInProgress: WorkInProgress = .init()
        var books: Books = .init()
        XCTAssert(books.wips.isEmpty)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips, [workInProgress.id: workInProgress])
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips, [workInProgress.id: workInProgress],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress,
                       "Adding element with the same id should not duplicate.")

        let workInProgress2: WorkInProgress = .init()
        books.add(workInProgress: workInProgress2)
        XCTAssertEqual(books.wips.count, 2)
        XCTAssertEqual(books.workInProgress(forID: workInProgress2.id), workInProgress2)
    }

    func testAddRawMaterial() {
        let rawMaterial: RawMaterial = .init()
        var books: Books = .init()
        XCTAssert(books.rawMaterials.isEmpty)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials, [rawMaterial.id: rawMaterial])
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials, [rawMaterial.id: rawMaterial],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial,
                       "Adding element with the same id should not duplicate.")

        let rawMaterial2: RawMaterial = .init()
        books.add(rawMaterial: rawMaterial2)
        XCTAssertEqual(books.rawMaterials.count, 2)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial2.id), rawMaterial2)
    }

}
