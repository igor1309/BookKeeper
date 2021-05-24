/// `SimpleAccount` is a `just money` account, a type of account that is debited and credited with just amount.
///
/// For example, `Cash` account is a SimpleAccount.
/// For comparison, an Order is needed to debit or credit `Inventory` account.
public protocol SimpleAccount: AccountProtocol {
    mutating func debit(amount: Double) throws
    mutating func credit(amount: Double) throws
}

public extension SimpleAccount {
    mutating func debit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError<Self>.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                self.amount += amount
            case .passive:
                if self.amount < amount {
                    throw AccountError<Self>.insufficientBalance(self)
                } else {
                    self.amount -= amount
                }
        }
    }

    mutating func credit(amount: Double) throws {
        guard amount >= 0 else { throw AccountError<Self>.negativeAmount}

        switch kind {
            case .active, .bothActivePassive:
                if self.amount < amount {
                    throw AccountError<Self>.insufficientBalance(self)
                } else {
                    self.amount -= amount
                }
            case .passive:
                self.amount += amount
        }
    }

}
