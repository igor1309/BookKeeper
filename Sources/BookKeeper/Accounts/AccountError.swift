/// `AccountError` is used to present errors occurring when recording account transactions.
///
/// For example, `insufficientBalance` is thrown when active account is credited for amount that is bigger than account balance.
public enum AccountError: Error, Equatable {
    /// `insufficientBalance` error is thrown when active account is credited for amount that is bigger than account balance.
    case insufficientBalance

    /// `negativeAmount` error is thrown when account is debited or credited with negative value (amount).
    case negativeAmount
}
