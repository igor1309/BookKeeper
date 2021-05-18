import Foundation

public struct Client: Equatable, Hashable, Identifiable {
    #warning("change id to type safe id")
    /// # Type-safe identifiers
    ///
    /// Sources:
    /// https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/)
    /// https://www.donnywals.com/creating-type-safe-identifiers-for-your-codable-models/
    /// https://www.pointfree.co/episodes/ep12-tagged
    ///
    /// Best polished solution is https://github.com/pointfreeco/swift-tagged/ wrapped is Swift Package.
    ///
    public let id: UUID
    public var receivables: AccountReceivable

    public init(id: UUID = UUID(),
                receivables: AccountReceivable = .init()
    ) {
        self.id = id
        self.receivables = receivables
    }
}

extension Client: CustomStringConvertible {
    public var description: String {
        "Client(receivables: \(receivables))"
    }
}
