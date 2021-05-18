import Foundation

public struct FinishedGood: Product {
    #warning("change id to type safe id")
    public let id: UUID

    public var inventory: InventoryAccount
    public var cogs: COGS

    public func cost() -> Double? {
        inventory.cost()
    }

    public init(id: UUID = UUID(),
                inventory: InventoryAccount = .init(),
                cogs: COGS = .init()
    ) {
        self.id = id
        self.inventory = inventory
        self.cogs = cogs
    }
}

extension FinishedGood: CustomStringConvertible {
    public var description: String {
        "FinishedGood(inventory: \(inventory), cogs: \(cogs))"
    }
}
