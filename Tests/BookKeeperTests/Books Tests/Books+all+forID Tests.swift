import XCTest
// @testable
import BookKeeper

// MARK: - All
extension BooksTests {

    func testRawMaterialsAll() { XCTFail("finish test") }

    func testWipsAll() { XCTFail("finish test") }

    func testFinishedGoodsAll() { XCTFail("finish test") }

    func testClientsAll() { XCTFail("finish test") }

    func testEquipmentAll() { XCTFail("finish test") }

}

// MARK: - forID
extension BooksTests {

    func testRawMaterialForID() throws {
        var books: Books = .init()
        let sample: RawMaterial = .sample
        XCTAssertNil(books.rawMaterial(forID: sample.id))

        let rawMaterial = try books.addRawMaterial(name: "rawMaterial")
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)
    }

    func testWorkInProgressForID() throws {
        var books: Books = .init()
        let sample: WorkInProgress = .init(name: "WorkInProgress")
        XCTAssertNil(books.workInProgress(forID: sample.id))

        let workInProgress = try books.addWorkInProgress(name: "WorkInProgress")
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)
    }

    func testFinishedGoodForID() throws {
        var books: Books = .init()
        let sample: FinishedGood = .sample
        XCTAssertNil(books.finishedGood(forID: sample.id))

        let finishedGood = try books.addFinishedGood(name: "finishedGood")
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
    }

    func testClientForID() throws {
        var books: Books = .init()
        let sample: Client = .sample
        XCTAssertNil(books.client(forID: sample.id))

        let client = try books.addClient(name: "client")
        XCTAssertEqual(books.client(forID: client.id), client)
    }

    func testSupplierForID() throws {
        var books: Books = .init()
        let sample: Supplier = .sample
        XCTAssertNil(books.supplier(forID: sample.id))

        let supplier = try books.addSupplier(name: "supplier")
        XCTAssertEqual(books.supplier(forID: supplier.id), supplier)
    }

    func testEquipmentForID() {
        let equipment: Equipment = .init(name: "freezer", lifetime: 7, value: 1_000_000)

        let books0: Books = .init()
        XCTAssertNil(books0.equipment(forID: equipment.id))

        let books: Books = .init(equipments: [equipment])
        XCTAssertEqual(books.equipment(forID: equipment.id), equipment)
    }

}
