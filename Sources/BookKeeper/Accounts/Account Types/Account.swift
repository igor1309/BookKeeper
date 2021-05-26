/// `Account` is a `just money` account, a type of account that is debited and credited with just amount.
///
/// For example, `Cash` account is an Account.
/// For comparison, an Order is needed to debit or credit `Inventory` account.
public struct Account<AccountType: AccountTypeProtocol> {
    public let name: String
    public var amount: Double

    public init(name: String = AccountType.defaultName,
                amount: Double = 0
    ) {
        self.name = name
        self.amount = amount
    }

    public mutating func debit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError<AccountType>.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                self.amount += amount
            case .passive:
                if self.amount < amount {
                    throw AccountError<AccountType>.insufficientBalance(self)
                } else {
                    self.amount -= amount
                }
        }
    }

    public mutating func credit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError<AccountType>.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                if self.amount < amount {
                    throw AccountError<AccountType>.insufficientBalance(self)
                } else {
                    self.amount -= amount
                }
            case .passive:
                self.amount += amount
        }
    }

}

extension Account: AccountProtocol {
    public var kind: AccountKind { AccountType.kind }
    public var group: AccountGroup { AccountType.group }
}

extension Account: CustomStringConvertible {
    public var description: String {
        "\(name)(\(group.rawValue) (\(kind)); \(amount))"
    }
}

