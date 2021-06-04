// MARK: Add Objects to Books

public extension Books {
    #warning("rename")
    enum AddError: Error {
        case duplicateName
    }

    @discardableResult
    mutating func addClient(name: String) throws -> Client {
        guard !clients.contains(name, at: \.name) else {
            throw AddError.duplicateName
        }

        let client: Client = .init(name: name)
        clients[client.id] = client
        return  client
    }

    @discardableResult
    mutating func addSupplier(name: String) throws -> Supplier {
        guard !suppliers.contains(name, at: \.name) else {
            throw AddError.duplicateName
        }

        let supplier: Supplier = .init(name: name)
        suppliers[supplier.id] = supplier
        return supplier
    }

    @discardableResult
    mutating func addRawMaterial(name: String) throws -> RawMaterial {
        guard !rawMaterials.contains(name, at: \.name) else {
            throw AddError.duplicateName
        }

        let rawMaterial: RawMaterial = .init(name: name)
        rawMaterials[rawMaterial.id] = rawMaterial
        return rawMaterial
    }

    @discardableResult
    mutating func addWorkInProgress(name: String) throws -> WorkInProgress {
        guard !wips.contains(name, at: \.name) else {
            throw AddError.duplicateName
        }

        let workInProgress: WorkInProgress = .init(name: name)
        wips[workInProgress.id] = workInProgress
        return workInProgress
    }

    @discardableResult
    mutating func addFinishedGood(name: String) throws -> FinishedGood {
        guard !finishedGoods.contains(name, at: \.name) else {
            throw AddError.duplicateName
        }

        let finishedGood: FinishedGood = .init(name: name)
        finishedGoods[finishedGood.id] = finishedGood
        return finishedGood
    }

}
