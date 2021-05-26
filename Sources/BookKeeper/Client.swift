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
    public let name: String
    #warning("a downside of using account without static properties is that we can't define here a kind of account")
    public var receivables: Account<AccountsReceivable>

    #warning("change parameter name from amount to more telling")
    public init(id: UUID = UUID(),
                name: String,
                initialReceivables amount: Double = 0
    ) {
        self.id = id
        self.name = name
        self.receivables = .init(name: name, amount: amount)
    }

    #warning("this init conflicts. fix & write tests. see ClientTests")
    /// Failable initialiser that checks Account Kind and AccountGroup
//    public init?(id: UUID = UUID(),
//                 name: String,
//                 receivables: SimpleAccount
//    ) {
//        guard receivables.kind == .active,
//              receivables.group == .balanceSheet(.asset(.currentAsset(.accountsReceivable))) else {
//            return nil
//        }
//
//        self.id = id
//        self.name = name
//        self.receivables = receivables
//    }

}

extension Client: CustomStringConvertible {
    public var description: String {
        "Client \(name)(receivables: \(receivables))"
    }
}
