import Foundation
import Tagged

public struct Supplier: Equatable, Hashable, Identifiable {
    public let id: Tagged<Self, UUID>
    public let name: String
    public var payables: Account<AccountsPayable>

    public init(id: UUID = UUID(),
                name: String,
                initialPayables amount: Double = 0
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.name = name
        self.payables = .init(name: name, amount: amount)
    }

}

extension Supplier: CustomStringConvertible {
    public var description: String {
        "Supplier \(name)(payables: \(payables))"
    }
}
