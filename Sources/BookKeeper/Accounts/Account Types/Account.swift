/// `Account` is a `just money` account, a type of account that is debited and credited with just amount.
///
/// For example, `Cash` account is an Account.
/// For comparison, an Order is needed to debit or credit `Inventory` account.
public struct Account: AccountProtocol {
    public var kind: AccountKind { group.kind }
    public let group: AccountGroup
    private(set) var amount: Double

    public init(group: AccountGroup,
                amount: Double = 0
    ) {
        self.group = group
        self.amount = amount
    }

    public var balance: Double { amount }

}

extension Account: CustomStringConvertible {
    public var description: String {
        "\(group.rawValue), \(kind): \(amount)"
    }
}

extension Account {
    public mutating func debit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                self.amount += amount

            case .passive:
                if self.amount < amount {
                    throw AccountError.insufficientBalance(self.group)
                } else {
                    self.amount -= amount
                }
        }
    }

    public mutating func credit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                if self.amount < amount {
                    throw AccountError.insufficientBalance(self.group)
                } else {
                    self.amount -= amount
                }

            case .passive:
                self.amount += amount
        }
    }

}
