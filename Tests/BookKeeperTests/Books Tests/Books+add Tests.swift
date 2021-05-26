import XCTest
// @testable
import BookKeeper

// MARK: - Add
extension BooksTests {
    func testAddClient() {
        let client: Client = .sample
        var books: Books = .init()
        XCTAssert(books.clientsAll().isEmpty)

        books.add(client: client)
        XCTAssertEqual(books.clientsAll().count, 1)
        XCTAssertEqual(books.clientsAll(), [client.id: client])
        XCTAssertEqual(books.client(forID: client.id), client)

        books.add(client: client)
        XCTAssertEqual(books.clientsAll().count, 1)
        XCTAssertEqual(books.clientsAll(), [client.id: client],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.client(forID: client.id), client,
                       "Adding element with the same id should not duplicate.")

        let client2: Client = .sample
        books.add(client: client2)
        XCTAssertEqual(books.clientsAll().count, 2)
        XCTAssertEqual(books.client(forID: client2.id), client2)
    }

    func testAddFinishedGood() {
        let finishedGood: FinishedGood = .sample
        var books: Books = .init()
        XCTAssert(books.finishedGoodsAll().isEmpty)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)
        XCTAssertEqual(books.finishedGoodsAll(), [finishedGood.id: finishedGood])
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGoodsAll().count, 1)
        XCTAssertEqual(books.finishedGoodsAll(), [finishedGood.id: finishedGood],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood,
                       "Adding element with the same id should not duplicate.")

        let finishedGood2: FinishedGood = .sample
        books.add(finishedGood: finishedGood2)
        XCTAssertEqual(books.finishedGoodsAll().count, 2)
        XCTAssertEqual(books.finishedGood(forID: finishedGood2.id), finishedGood2)
    }

    func testAddWorkInProgress() {
        let workInProgress: WorkInProgress = .init()
        var books: Books = .init()
        XCTAssert(books.wipsAll().isEmpty)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.wipsAll(), [workInProgress.id: workInProgress])
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.wipsAll().count, 1)
        XCTAssertEqual(books.wipsAll(), [workInProgress.id: workInProgress],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress,
                       "Adding element with the same id should not duplicate.")

        let workInProgress2: WorkInProgress = .init()
        books.add(workInProgress: workInProgress2)
        XCTAssertEqual(books.wipsAll().count, 2)
        XCTAssertEqual(books.workInProgress(forID: workInProgress2.id), workInProgress2)
    }

    func testAddRawMaterial() {
        let rawMaterial: RawMaterial = .init()
        var books: Books = .init()
        XCTAssert(books.rawMaterialsAll().isEmpty)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterialsAll().count, 1)
        XCTAssertEqual(books.rawMaterialsAll(), [rawMaterial.id: rawMaterial])
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterialsAll().count, 1)
        XCTAssertEqual(books.rawMaterialsAll(), [rawMaterial.id: rawMaterial],
                       "Adding element with the same id should not duplicate.")
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial,
                       "Adding element with the same id should not duplicate.")

        let rawMaterial2: RawMaterial = .init()
        books.add(rawMaterial: rawMaterial2)
        XCTAssertEqual(books.rawMaterialsAll().count, 2)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial2.id), rawMaterial2)
    }

}

