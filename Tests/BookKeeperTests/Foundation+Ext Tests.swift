import XCTest
@testable import BookKeeper

final class FoundationExtTests: XCTestCase {
    func testTotalBalance() {
        let pairs = (1...10).map { (UUID(), Double($0)) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            let inventory: InventoryAccount = .init(qty: Int(value), amount: value * 10.0)
            return FinishedGood(name: "FinishedGood \(value)",
                                inventory: inventory)
        }
        XCTAssertEqual(finishedGoods.totalBalance(for: \.cogs), 0)
        XCTAssertEqual(finishedGoods.totalBalance(for: \.inventory), 550)
        XCTAssertEqual((1...10).reduce(0) { $0 + $1 * 10},
                       550)
    }

    func testTotalBalanceIsZero() {
        let pairs = (1...10).map { _ in (UUID(), 0.0) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let finishedGoods = dict.mapValues { (value: Double) -> FinishedGood in
            let inventory: InventoryAccount = .init(qty: Int(value), amount: value * 10.0)
            return FinishedGood(name: "FinishedGood \(value)",
                                inventory: inventory)
        }

        XCTAssert(finishedGoods.totalBalanceIsZero(for: \.cogs))
        XCTAssert(finishedGoods.totalBalanceIsZero(for: \.inventory))
    }

    func testCombineAccounts() {
        let pairs = (1...100).map { (UUID(), Double($0) * 1_000.0) }
        let dict = Dictionary(uniqueKeysWithValues: pairs)

        let balance = pairs.reduce(0) { $0 + $1.1 }

        let clients = dict.mapValues {
            Client(name: "Client \($0)", initialReceivables: $0)
        }
        XCTAssertEqual(
            clients.combined(\.receivables),
            Account<AccountsReceivable>(
                name: "Combined Accounts Receivable",
                amount: balance)
        )

        let suppliers = dict.mapValues {
            Supplier(name: "Supplier \($0)", initialPayables: $0)
        }
        XCTAssertEqual(
            suppliers.combined(\.payables),
            Account<AccountsPayable>(
                name: "Combined Accounts Payable",
                amount: balance)
        )
    }

}
