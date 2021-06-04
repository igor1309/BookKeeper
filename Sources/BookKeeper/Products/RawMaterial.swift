import Foundation
import Tagged

public struct RawMaterial: Product {
    public let id: Tagged<Self, UUID>
    public let name: String
    public var inventory: InventoryAccount

    public init(id: UUID = UUID(),
                name: String,
                initialInventoryQty qty: Int,
                initialInventoryValue amount: Double
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.name = name
        self.inventory = .init(type: .rawMaterials,
                               qty: qty,
                               amount: amount)
    }

    public init(id: UUID = UUID(), name: String) {
        self.init(id: id,
                  name: name,
                  initialInventoryQty: 0,
                  initialInventoryValue: 0
        )
    }
}

extension RawMaterial: CustomStringConvertible {
    public var description: String {
        "RawMaterial \(name)(inventory: \(inventory))"
    }
}
