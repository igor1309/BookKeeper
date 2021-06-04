import XCTest
@testable import BookKeeper

// MARK: Business Operations

extension BooksTests {
    func testPurchaseEquipmentUnknownSupplierError() throws {
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // create supplier and try to purchase asset
        let supplier: Supplier = .sample
        XCTAssertThrowsError(
            try books.purchaseEquipment(supplierID: supplier.id,
                                        assetName: "freezer",
                                        lifetimeInYears: 7,
                                        amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.equipments.isEmpty)
    }

    func testPurchaseEquipmentIncorrectLifetimeError() throws {
        let supplier: Supplier = .init(name: "Supplier")
        var books: Books = .init(suppliers: supplier)

        // confirm
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)

        // try to purchase asset with wrong lifetime
        XCTAssertThrowsError(
            try books.purchaseEquipment(supplierID: supplier.id,
                                        assetName: "freezer",
                                        lifetimeInYears: 0,
                                        amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.incorrectLifetime)
        }

        // confirm no change after error
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)
    }

    func testPurchaseEquipmentNonPositiveAmountError() {
        let supplier: Supplier = .init(name: "Supplier")
        var books: Books = .init(suppliers: supplier)

        // confirm
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)

        // try to purchase asset with wrong amount
        XCTAssertThrowsError(
            try books.purchaseEquipment(supplierID: supplier.id,
                                        assetName: "freezer",
                                        lifetimeInYears: 7,
                                        amountExVAT: 0)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.nonPositiveAmount)
        }

        // confirm no change after error
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)
    }

    func testPurchaseEquipmentNegativeVATError() {
        let supplier: Supplier = .init(name: "Supplier")
        var books: Books = .init(suppliers: supplier)

        // confirm
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)

        // try to purchase asset with negative VAT rate
        XCTAssertThrowsError(
            try books.purchaseEquipment(supplierID: supplier.id,
                                        assetName: "freezer",
                                        lifetimeInYears: 7,
                                        amountExVAT: 1_000_000,
                                        vatRate: -10/100)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.negativeVAT)
        }

        // confirm no change after error
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)
    }

    func testPurchaseEquipmentNoErrors() {
        let supplier: Supplier = .init(name: "Supplier")
        var books: Books = .init(suppliers: supplier)

        // confirm
        XCTAssert(books.equipments.isEmpty)
        XCTAssertEqual(Array(books.suppliers.values), [supplier])
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)

        // try to purchase
        XCTAssertNoThrow(
            try books.purchaseEquipment(supplierID: supplier.id,
                                        assetName: "freezer",
                                        lifetimeInYears: 13,
                                        amountExVAT: 1_000_000
            )
        )

        // confirm
        XCTAssertEqual(books.equipments.values.count, 1)
        XCTAssertEqual(books.equipments.values.first?.name, "freezer")
        XCTAssertEqual(books.equipments.values.first?.lifetime, 13)
        XCTAssertEqual(books.equipments.sum(for: \.initialValue), 1_000_000)

        XCTAssertEqual(books.ledger[.vatReceivable]?.balance, 200_000)

        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables),
                       1_200_000,
                       "Should include VAT")
        XCTAssertEqual(books.ledger[.payables]?.balance, 1_200_000,
                       "Should include VAT")
    }

}
