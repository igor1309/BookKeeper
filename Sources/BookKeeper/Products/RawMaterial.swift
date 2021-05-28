import Foundation
import Tagged

public struct RawMaterial: Product {
    public let id: Tagged<Self, UUID>
    public var inventory: InventoryAccount

    public init(id: UUID = UUID(),
                inventory: InventoryAccount = .init()
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.inventory = inventory
    }
}

extension RawMaterial: CustomStringConvertible {
    public var description: String {
        "RawMaterial(inventory: \(inventory))"
    }
}
