import XCTest
import BookKeeper

// MARK: All

extension BooksTests {

    func testRawMaterialsAll() {
        var books: Books = .init()
        XCTAssertEqual(books.rawMaterialsAll(), books.rawMaterials)

        books = .init(rawMaterials: .sample)
        XCTAssertEqual(books.rawMaterialsAll(), books.rawMaterials)
    }

    func testWipsAll() {
        var books: Books = .init()
        XCTAssertEqual(books.wipsAll(), books.wips)

        books = .init(wips: .sample)
        XCTAssertEqual(books.wipsAll(), books.wips)
    }

    func testFinishedGoodsAll() {
        var books: Books = .init()
        XCTAssertEqual(books.finishedGoodsAll(), books.finishedGoods)

        books = .init(finishedGoods: .sample)
        XCTAssertEqual(books.finishedGoodsAll(), books.finishedGoods)
    }

    func testClientsAll() {
        var books: Books = .init()
        XCTAssertEqual(books.clientsAll(), books.clients)

        books = .init(rawMaterials: .sample)
        XCTAssertEqual(books.clientsAll(), books.clients)
    }

    func testSuppliersAll() {
        var books: Books = .init()
        XCTAssertEqual(books.suppliersAll(), books.suppliers)

        books = .init(rawMaterials: .sample)
        XCTAssertEqual(books.suppliersAll(), books.suppliers)
    }

    func testEquipmentAll() {
        var books: Books = .init()
        XCTAssertEqual(books.equipmentsAll(), books.equipments)

        books = .init(equipments: .sample)
        XCTAssertEqual(books.equipmentsAll(), books.equipments)
    }

}
