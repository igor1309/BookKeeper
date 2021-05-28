import Foundation
import Tagged

public struct WorkInProgress: Product {
    public let id: Tagged<Self, UUID>
    public var inventory: InventoryAccount

    public init(id: UUID = UUID(),
                inventory: InventoryAccount = .init()
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.inventory = inventory
    }
}

extension WorkInProgress: CustomStringConvertible {
    public var description: String {
        "WorkInProgress(inventory: \(inventory))"
    }
}
