import XCTest
import BookKeeper

final class ClientTests: XCTestCase {
    func testClientInit() {
        let clientZero: Client = .init()
        XCTAssertEqual(clientZero.receivables.balance(), 0)

        let client: Client = Client(receivables: .init(amount: 9_900))
        XCTAssertEqual(client.receivables.balance(), 9_900)
    }

    func testDescription() {
        let clientZero: Client = .init()
        XCTAssertEqual(clientZero.description,
                       "Client(receivables: AccountReceivable(0.0))")

        let client: Client = Client(receivables: .init(amount: 9_900))
        XCTAssertEqual(client.description,
                       "Client(receivables: AccountReceivable(9900.0))")
    }

}
