public enum OrderProcessingError: Error {
    case wrongOrderType
    case noCost
}

public protocol OrderProcessingAccount: AccountProtocol {
    mutating func debit<Order: OrderProtocol>(order: Order) throws
    mutating func credit<Order: OrderProtocol>(order: Order) throws
}

public protocol SalesProcessingAccount: AccountProtocol {
    mutating func debit(salesOrder: SalesOrder) throws
    mutating func credit(salesOrder: SalesOrder) throws
}
