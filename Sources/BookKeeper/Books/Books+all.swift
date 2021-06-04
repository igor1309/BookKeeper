// MARK: All

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

    func suppliersAll() -> [Supplier.ID: Supplier] {
        suppliers
    }

    func equipmentsAll() -> [Equipment.ID: Equipment] {
        equipments
    }

}
