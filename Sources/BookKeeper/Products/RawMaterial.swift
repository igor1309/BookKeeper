import Foundation

public struct RawMaterial: Product {
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

extension RawMaterial: CustomStringConvertible {
    public var description: String {
        "RawMaterial(inventory: \(inventory))"
    }
}

