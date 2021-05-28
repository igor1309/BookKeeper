import Foundation
import Tagged

public struct Client: Equatable, Hashable, Identifiable {
    public let id: Tagged<Self, UUID>
    public let name: String
    public var receivables: Account<AccountsReceivable>

    public init(id: UUID = UUID(),
                name: String,
                initialReceivables amount: Double = 0
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.name = name
        self.receivables = .init(name: name, amount: amount)
    }

}

extension Client: CustomStringConvertible {
    public var description: String {
        "Client \(name)(receivables: \(receivables))"
    }
}
