/// `AccountError` is used to present errors occurring when recording account transactions.
///
/// For example, `insufficientBalance` is thrown when active account is credited for amount that is bigger than account balance.
#warning("should i use associated value for account in every enum case?")
public enum AccountError: Error, Equatable {
    /// `insufficientBalance` error is thrown when active account is credited for amount that is bigger than account balance.
    case insufficientBalance

    /// `negativeAmount` error is thrown when account is debited or credited with negative value (amount).
    case negativeAmount
}
