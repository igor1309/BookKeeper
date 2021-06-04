import Foundation
import Tagged

public struct WorkInProgress: Product {
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
        self.inventory = .init(type: .workInProgress,
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

extension WorkInProgress: CustomStringConvertible {
    public var description: String {
        "WorkInProgress \(name)(inventory: \(inventory))"
    }
}
