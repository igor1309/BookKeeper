import XCTest
// @testable
import BookKeeper

// MARK: - Business Operations
extension BooksTests {
    func testPayInvoice() throws {
        var books: Books = .init(cashAccount: .init(amount: 700_000))

        // confirm
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)
        XCTAssertEqual(books.cashAccount.balance, 700_000)

        let supplier: Supplier = .init(name: "Supplier")
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balance.isZero)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 0)
        XCTAssertEqual(books.cashAccount.balance, 700_000)

        // add supplier and try to pay invoice
        books.add(supplier: supplier)
        XCTAssertNoThrow(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 1_000_000)
        )

        // confirm change
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 1_200_000, "Should include VAT")
        XCTAssertEqual(books.payables.balance, 1_200_000, "Should include VAT")
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000, "Should not include VAT")
        XCTAssertEqual(books.cashAccount.balance, 700_000)

        // try to pay smaller invoice
        XCTAssertThrowsError(
            try books.payInvoice(supplierID: supplier.id, amount: 800_000)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(books.cashAccount))
        }
        // confirm no change after error
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 1_200_000, "Should include VAT")
        XCTAssertEqual(books.payables.balance, 1_200_000, "Should include VAT")
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000, "Should not include VAT")
        XCTAssertEqual(books.cashAccount.balance, 700_000)

        XCTAssertNoThrow(
            try books.payInvoice(supplierID: supplier.id, amount: 600_000)
        )
        // confirm change
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 600_000)
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 600_000)
        XCTAssertEqual(books.payables.balance, 600_000)
        XCTAssertEqual(books.cashAccount.balance, 100_000)
    }

    func testPayInvoice2() throws {
        var books: Books = .init(cashAccount: .init(amount: 2_000_000))

        // confirm
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 0)
        XCTAssertEqual(books.cashAccount.balance, 2_000_000)

        let supplier: Supplier = .init(name: "Supplier")
        XCTAssertThrowsError(
            try books.purchaseFixedAsset(supplierID: supplier.id,
                                         assetName: "freezer",
                                         lifetimeInYears: 7,
                                         amountExVAT: 1_000_000)
        ) { error in
            XCTAssertEqual(error as! Books.BooksError,
                           Books.BooksError.unknownSupplier)
        }

        // confirm no change after error
        XCTAssert(books.suppliers.totalBalance(for: \.payables).isZero)
        XCTAssert(books.payables.balanceIsZero)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 0)
        XCTAssertEqual(books.cashAccount.balance, 2_000_000)

        // add supplier and try to purchase asset
        books.add(supplier: supplier)
        try books.purchaseFixedAsset(supplierID: supplier.id,
                                     assetName: "freezer",
                                     lifetimeInYears: 7,
                                     amountExVAT: 1_000_000
        )

        // confirm
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 1_200_000, "Should include VAT")
        XCTAssertEqual(books.payables.balance, 1_200_000, "Should include VAT")
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000, "Should not include VAT")
        XCTAssertEqual(books.cashAccount.balance, 2_000_000)

        // try to pay more than owed
        XCTAssertThrowsError(
            try books.payInvoice(supplierID: supplier.id, amount: 2_000_000)
        ) { error in
            XCTAssertEqual(error as! AccountError,
                           AccountError.insufficientBalance(books.suppliers[supplier.id]!.payables))
        }

        // confirm no change after error
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 1_200_000, "Should include VAT")
        XCTAssertEqual(books.payables.balance, 1_200_000, "Should include VAT")
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000, "Should not include VAT")
        XCTAssertEqual(books.cashAccount.balance, 2_000_000)

        // try to pay invoice
        XCTAssertNoThrow(
            try books.payInvoice(supplierID: supplier.id, amount: 1_000_000)
            )

        // confirm
        XCTAssertEqual(books.suppliers.totalBalance(for: \.payables), 200_000)
        XCTAssertEqual(books.payables.balance, 200_000)
        XCTAssertEqual(books.fixedAssets.sum(for: \.value), 1_000_000, "Should not include VAT")
        XCTAssertEqual(books.cashAccount.balance, 1_000_000)
    }

}
