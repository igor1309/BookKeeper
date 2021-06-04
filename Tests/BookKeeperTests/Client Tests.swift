import XCTest
import BookKeeper

final class ClientTests: XCTestCase {
    func testClientInit() {
        let clientZero: Client = .init(name: "Client0")
        XCTAssert(clientZero.receivables.balanceIsZero)

        let client: Client = Client(name: "Client", initialReceivables: 9_900)
        XCTAssertEqual(client.receivables.balance, 9_900)
    }

    func testDescription() {
        let clientZero: Client = .init(name: "Client0")
        XCTAssertEqual(clientZero.description,
                       "Client Client0(receivables: Accounts Receivable, active: 0.0)")

        let client: Client = Client(name: "Client", initialReceivables: 9_900)
        XCTAssertEqual(client.description,
                       "Client Client(receivables: Accounts Receivable, active: 9900.0)")
    }

}
