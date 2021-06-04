// MARK: forID

public extension Books {
    func rawMaterial(forID id: RawMaterial.ID) -> RawMaterial? {
        rawMaterials[id]
    }
    func workInProgress(forID id: WorkInProgress.ID) -> WorkInProgress? {
        wips[id]
    }
    func finishedGood(forID id: FinishedGood.ID) -> FinishedGood? {
        finishedGoods[id]
    }
    func client(forID id: Client.ID) -> Client? {
        clients[id]
    }
    func supplier(forID id: Supplier.ID) -> Supplier? {
        suppliers[id]
    }
    func equipment(forID id: Equipment.ID) -> Equipment? {
        equipments[id]
    }

}
