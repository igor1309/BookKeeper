import Foundation

public struct Client: Equatable, Hashable, Identifiable {
    #warning("change id to type safe id")
    public let id: UUID
    public let name: String
    public var receivables: Account<AccountsReceivable>

    public init(id: UUID = UUID(),
                name: String,
                initialReceivables amount: Double = 0
    ) {
        self.id = id
        self.name = name
        self.receivables = .init(name: name, amount: amount)
    }

}

extension Client: CustomStringConvertible {
    public var description: String {
        "Client \(name)(receivables: \(receivables))"
    }
}
