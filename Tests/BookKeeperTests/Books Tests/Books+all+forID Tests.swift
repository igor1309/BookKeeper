import XCTest
// @testable
import BookKeeper

// MARK: - All & forID
extension BooksTests {

    func testRawMaterialsAll() { XCTFail("finish test") }

    func testWipsAll() { XCTFail("finish test") }

    func testFinishedGoodsAll() { XCTFail("finish test") }

    func testClientsAll() { XCTFail("finish test") }

    func testRawMaterialForID() {
        var books: Books = .init()
        let rawMaterial: RawMaterial = .init()
        XCTAssertNil(books.rawMaterial(forID: rawMaterial.id))

        books.add(rawMaterial: rawMaterial)
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)
    }

    func testWorkInProgressForID() {
        var books: Books = .init()
        let workInProgress: WorkInProgress = .init()
        XCTAssertNil(books.workInProgress(forID: workInProgress.id))

        books.add(workInProgress: workInProgress)
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)
    }

    func testFinishedGoodForID() {
        var books: Books = .init()
        let finishedGood: FinishedGood = .init()
        XCTAssertNil(books.finishedGood(forID: finishedGood.id))

        books.add(finishedGood: finishedGood)
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
    }

    func testClientForID() {
        var books: Books = .init()
        let client: Client = .init()
        XCTAssertNil(books.client(forID: client.id))

        books.add(client: client)
        XCTAssertEqual(books.client(forID: client.id), client)
    }

}
