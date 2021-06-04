// MARK: Add Objects to Books

public extension Books {

    /// Returns new Client with given name, added to books with zero receivables.
    /// - Parameter name: Client's name.
    /// - Throws: If name is already used in books.
    /// - Returns: New Client with previously unused name.
    @discardableResult
    mutating func addClient(name: String) throws -> Client {
        guard !clients.contains(name, at: \.name) else {
            throw BooksError.duplicateName
        }

        let client: Client = .init(name: name)
        clients[client.id] = client
        return  client
    }

    /// Returns new Supplier with given name, added to books with zero payables.
    /// - Parameter name: Supplier's name/
    /// - Throws: If name is already used in books.
    /// - Returns: New Supplier with previously unused name.
    @discardableResult
    mutating func addSupplier(name: String) throws -> Supplier {
        guard !suppliers.contains(name, at: \.name) else {
            throw BooksError.duplicateName
        }

        let supplier: Supplier = .init(name: name)
        suppliers[supplier.id] = supplier
        return supplier
    }

    /// Returns new Raw Material with given name, added to books with zero inventory.
    /// - Parameter name: Raw Material's name.
    /// - Throws: If name is already used in books.
    /// - Returns: New Raw Material with previously unused name
    @discardableResult
    mutating func addRawMaterial(name: String) throws -> RawMaterial {
        guard !rawMaterials.contains(name, at: \.name) else {
            throw BooksError.duplicateName
        }

        let rawMaterial: RawMaterial = .init(name: name)
        rawMaterials[rawMaterial.id] = rawMaterial
        return rawMaterial
    }

    /// Returns new Work in Progress with given name, added to books with zero inventory.
    /// - Parameter name: Work in Progress's name.
    /// - Throws: If name is already used in books.
    /// - Returns: New Work in Progress with previously unused name
    @discardableResult
    mutating func addWorkInProgress(name: String) throws -> WorkInProgress {
        guard !wips.contains(name, at: \.name) else {
            throw BooksError.duplicateName
        }

        let workInProgress: WorkInProgress = .init(name: name)
        wips[workInProgress.id] = workInProgress
        return workInProgress
    }

    /// Returns new Finished Good with given name, added to books with zero inventory.
    /// - Parameter name: Finished Good's name.
    /// - Throws: If name is already used in books.
    /// - Returns: New Finished Good with previously unused name
    @discardableResult
    mutating func addFinishedGood(name: String) throws -> FinishedGood {
        guard !finishedGoods.contains(name, at: \.name) else {
            throw BooksError.duplicateName
        }

        let finishedGood: FinishedGood = .init(name: name)
        finishedGoods[finishedGood.id] = finishedGood
        return finishedGood
    }

}
