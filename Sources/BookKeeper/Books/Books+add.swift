// MARK: - Add
public extension Books {
    mutating func add(client: Client) {
        clients[client.id] = client
    }

    mutating func add(finishedGood: FinishedGood) {
        finishedGoods[finishedGood.id] = finishedGood
    }

    mutating func add(workInProgress wip: WorkInProgress) {
        wips[wip.id] = wip
    }

    mutating func add(rawMaterial: RawMaterial) {
        rawMaterials[rawMaterial.id] = rawMaterial
    }
}
