import Foundation

public struct Supplier: Equatable, Hashable, Identifiable {
    #warning("change id to type safe id")
    public let id: UUID
    public let name: String
    public var payables: Account<AccountsPayable>

    public init(id: UUID = UUID(),
                name: String,
                initialPayables amount: Double = 0
    ) {
        self.id = id
        self.name = name
        self.payables = .init(name: name, amount: amount)
    }

}

extension Supplier: CustomStringConvertible {
    public var description: String {
        "Supplier \(name)(payables: \(payables))"
    }
}

