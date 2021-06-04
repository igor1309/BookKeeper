import XCTest
import BookKeeper

// MARK: Add Objects to Books

extension BooksTests {
    func testAddClientDuplicateNameError() throws {
        // books with client
        var books: Books = .init(
            clients: Client(name: "New Client")
        )

        // confirm
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.first?.value.name, "New Client")
        XCTAssertEqual(books.clients.first?.value.receivables.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 0)

        // try add new client
        XCTAssertThrowsError(
            try books.addClient(name: "New Client"),
            "Should throw an error if same name is used."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.duplicateName)
        }

        // confirm no change after error
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients.first?.value.name, "New Client")
        XCTAssertEqual(books.clients.first?.value.receivables.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.receivables]?.balance, 0)
    }

    func testAddClientNoError() throws {
        // empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // add new client
        let client = try books.addClient(name: "New client")

        // confirm
        XCTAssertEqual(client.receivables.balance, 0)
        XCTAssertEqual(books.clients.count, 1)
        XCTAssertEqual(books.clients, [client.id: client])
        XCTAssertEqual(books.client(forID: client.id), client)
        XCTAssert(books.ledger.isEmpty, "Adding the Client should not change balance.")

        // add another client
        XCTAssertNoThrow(try books.addClient(name: "Another Client"))

        // confirm
        XCTAssertEqual(client.receivables.balance, 0)
        XCTAssertEqual(books.clients.count, 2)
        XCTAssert(books.ledger.isEmpty, "Adding the Client should not change balance.")

    }

    func testAddSupplierDuplicateNameError() throws {
        // books with supplier
        var books: Books = .init(
            suppliers: Supplier(name: "New Supplier")
        )

        // confirm
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.name, "New Supplier")
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)

        // try add new supplier
        XCTAssertThrowsError(
            try books.addSupplier(name: "New Supplier"),
            "Should throw an error if same name is used."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.duplicateName)
        }

        // confirm no change after error
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers.first?.value.name, "New Supplier")
        XCTAssertEqual(books.suppliers.first?.value.payables.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.payables]?.balance, 0)
    }

    func testAddSupplierNoError() throws {
        // empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // add new supplier
        let supplier = try books.addSupplier(name: "New supplier")

        // confirm
        XCTAssertEqual(supplier.payables.balance, 0)
        XCTAssertEqual(books.suppliers.count, 1)
        XCTAssertEqual(books.suppliers, [supplier.id: supplier])
        XCTAssertEqual(books.supplier(forID: supplier.id), supplier)
        XCTAssert(books.ledger.isEmpty, "Adding the Supplier should not change balance.")

        // add another supplier
        XCTAssertNoThrow(try books.addSupplier(name: "Another Supplier"))

        // confirm
        XCTAssertEqual(supplier.payables.balance, 0)
        XCTAssertEqual(books.suppliers.count, 2)
        XCTAssert(books.ledger.isEmpty, "Adding the Supplier should not change balance.")

    }

    func testAddRawMaterialDuplicateNameError() throws {
        // books with rawMaterial
        var books: Books = .init(
            rawMaterials: RawMaterial(name: "New RawMaterial")
        )

        // confirm
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.first?.value.name, "New RawMaterial")
        XCTAssertEqual(books.rawMaterials.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 0)

        // try add new rawMaterial
        XCTAssertThrowsError(
            try books.addRawMaterial(name: "New RawMaterial"),
            "Should throw an error if same name is used."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.duplicateName)
        }

        // confirm no change after error
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials.first?.value.name, "New RawMaterial")
        XCTAssertEqual(books.rawMaterials.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.rawInventory]?.balance, 0)
    }

    func testAddRawMaterialNoError() throws {
        // empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // add new rawMaterial
        let rawMaterial = try books.addRawMaterial(name: "New rawMaterial")

        // confirm
        XCTAssertEqual(rawMaterial.inventory.balance, 0)
        XCTAssertEqual(books.rawMaterials.count, 1)
        XCTAssertEqual(books.rawMaterials, [rawMaterial.id: rawMaterial])
        XCTAssertEqual(books.rawMaterial(forID: rawMaterial.id), rawMaterial)
        XCTAssert(books.ledger.isEmpty, "Adding the RawMaterial should not change balance.")

        // add another rawMaterial
        XCTAssertNoThrow(try books.addRawMaterial(name: "Another RawMaterial"))

        // confirm
        XCTAssertEqual(rawMaterial.inventory.balance, 0)
        XCTAssertEqual(books.rawMaterials.count, 2)
        XCTAssert(books.ledger.isEmpty, "Adding the RawMaterial should not change balance.")
    }

    func testAddWorkInProgressDuplicateNameError() throws {
        // books with workInProgress
        var books: Books = .init(
            wips: WorkInProgress(name: "New WorkInProgress")
        )

        // confirm
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.first?.value.name, "New WorkInProgress")
        XCTAssertEqual(books.wips.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 0)

        // try add new workInProgress
        XCTAssertThrowsError(
            try books.addWorkInProgress(name: "New WorkInProgress"),
            "Should throw an error if same name is used."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.duplicateName)
        }

        // confirm no change after error
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips.first?.value.name, "New WorkInProgress")
        XCTAssertEqual(books.wips.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 1)
        XCTAssertEqual(books.ledger[.wipsInventory]?.balance, 0)
    }

    func testAddWorkInProgressNoError() throws {
        // empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // add new workInProgress
        let workInProgress = try books.addWorkInProgress(name: "New workInProgress")

        // confirm
        XCTAssertEqual(workInProgress.inventory.balance, 0)
        XCTAssertEqual(books.wips.count, 1)
        XCTAssertEqual(books.wips, [workInProgress.id: workInProgress])
        XCTAssertEqual(books.workInProgress(forID: workInProgress.id), workInProgress)
        XCTAssert(books.ledger.isEmpty, "Adding the WorkInProgress should not change balance.")

        // add another workInProgress
        XCTAssertNoThrow(try books.addWorkInProgress(name: "Another WorkInProgress"))

        // confirm
        XCTAssertEqual(workInProgress.inventory.balance, 0)
        XCTAssertEqual(books.wips.count, 2)
        XCTAssert(books.ledger.isEmpty, "Adding the WorkInProgress should not change balance.")
    }

    func testAddFinishedGoodDuplicateNameError() throws {
        // books with finishedGood
        var books: Books = .init(
            finishedGoods: FinishedGood(name: "New FinishedGood")
        )

        // confirm
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.first?.value.name, "New FinishedGood")
        XCTAssertEqual(books.finishedGoods.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 0)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 0)

        // try add new finishedGood
        XCTAssertThrowsError(
            try books.addFinishedGood(name: "New FinishedGood"),
            "Should throw an error if same name is used."
        ) { error in
            XCTAssertEqual(error as? Books.BooksError,
                           Books.BooksError.duplicateName)
        }

        // confirm no change after error
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods.first?.value.name, "New FinishedGood")
        XCTAssertEqual(books.finishedGoods.first?.value.inventory.balance, 0)
        XCTAssertEqual(books.ledger.count, 2)
        XCTAssertEqual(books.ledger[.finishedInventory]?.balance, 0)
        XCTAssertEqual(books.ledger[.cogs]?.balance, 0)

    }

    func testAddFinishedGoodNoError() throws {
        // empty books
        var books: Books = .init()

        // confirm
        XCTAssert(books.isEmpty)

        // add new finishedGood
        let finishedGood = try books.addFinishedGood(name: "New finishedGood")

        // confirm
        XCTAssertEqual(finishedGood.inventory.balance, 0)
        XCTAssertEqual(books.finishedGoods.count, 1)
        XCTAssertEqual(books.finishedGoods, [finishedGood.id: finishedGood])
        XCTAssertEqual(books.finishedGood(forID: finishedGood.id), finishedGood)
        XCTAssert(books.ledger.isEmpty, "Adding the FinishedGood should not change balance.")

        // add another finishedGood
        XCTAssertNoThrow(try books.addFinishedGood(name: "Another FinishedGood"))

        // confirm
        XCTAssertEqual(finishedGood.inventory.balance, 0)
        XCTAssertEqual(books.finishedGoods.count, 2)
        XCTAssert(books.ledger.isEmpty, "Adding the FinishedGood should not change balance.")
    }

}
