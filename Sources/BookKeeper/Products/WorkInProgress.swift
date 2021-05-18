import Foundation

public struct WorkInProgress: Product {
    #warning("replace with type-safe ID")
    public let id: UUID

    public var inventory: InventoryAccount

    public init(id: UUID = UUID(),
                inventory: InventoryAccount = .init()
    ) {
        self.id = id
        self.inventory = inventory
    }
}

extension WorkInProgress: CustomStringConvertible {
    public var description: String {
        "WorkInProgress(inventory: \(inventory))"
    }
}
