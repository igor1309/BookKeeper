// MARK: - All & forID
public extension Books {
    func rawMaterialsAll() -> [RawMaterial.ID: RawMaterial] {
        rawMaterials
    }
    func wipsAll() -> [WorkInProgress.ID: WorkInProgress] {
        wips
    }
    func finishedGoodsAll() -> [FinishedGood.ID: FinishedGood] {
        finishedGoods
    }
    func clientsAll() -> [Client.ID: Client] {
        clients
    }

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

}
