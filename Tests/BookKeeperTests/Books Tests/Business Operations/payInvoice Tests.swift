import XCTest
@testable import BookKeeper

// MARK: Business Operations

extension BooksTests {
     func testPayInvoiceUnknownSupplierError() throws {
        // create empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.ledger.isEmpty)

        // try to pay invoice
        XCTAssertThrowsError(
            try books.payInvoice(amount: 10_000_000, to: Supplier.sample.id)
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.suppliers.isEmpty)
        XCTAssert(books.ledger.isEmpty)
    }

    func testPayInvoiceInsufficientBalanceErrors() throws {
        // books with supplier
        var books: Books = .init(
            suppliers: Supplier.sample
        )

        // confirm
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.id, Supplier.sample.id)
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 37_555)

        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555)

        // try to pay huge invoice
        XCTAssertThrowsError(
            try books.payInvoice(amount: 10_000_000, to: Supplier.sample.id)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(.payables))
        }

        // confirm no change after error
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.id, Supplier.sample.id)
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 37_555)

        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555)

        // try to pay small invoice
        XCTAssertThrowsError(
            try books.payInvoice(amount: 30_000, to: Supplier.sample.id)
        ) { error in
            XCTAssertEqual(error as? AccountError,
                           AccountError.insufficientBalance(.cash))
        }

        // confirm no change after error
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.id, Supplier.sample.id)
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 37_555)

        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555)
    }

    func testPayInvoiceNoErrors() {
        var books: Books = .init(
            suppliers: Supplier.sample,
            ledger: [
                .init(group: .cash, amount: 100_000)
            ]
        )

        // confirm
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.id, Supplier.sample.id)
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 37_555)

        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.cash]?.balance, 100_000)
        XCTAssertEqual(books.ledger[.payables]?.balance, 37_555)

        // try to pay invoice
        XCTAssertNoThrow(
            try books.payInvoice(amount: 30_000, to: Supplier.sample.id)
        )

        // confirm
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.id, Supplier.sample.id)
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 7_555)

        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.cash]?.balance, 70_000)
        XCTAssertEqual(books.ledger[.payables]?.balance, 7_555)
    }

}
