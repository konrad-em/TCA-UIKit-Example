import XCTest
import ComposableArchitecture
import CombineSchedulers
import Combine
import Utils

@testable import Investments

extension FundsProvider {
    public static let mock = Self {
        Just([.fixture(), .fixture(name: "Slow & Steady")])
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}

extension Fund {
    static func fixture(
        name: String = "Balanced Bundle"
    ) -> Self {
        .init(name: name)
    }
}

class PortfolioTests: XCTestCase {
    private let scheduler = DispatchQueue.testScheduler

    func test() {
        let funds: [Fund] = [.fixture(), .fixture(name: "Slow & Steady")]
        
        TestStore(
            initialState: Portfolio.State(),
            reducer: Portfolio.reducer,
            environment: Portfolio.Environment(
                fundsProvider: .mock,
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        .assert(
            ///
            .send(.viewDidLoad) {
                $0.funds = .loading(previous: [])
            },
            /// Advance test scheduler to handle async actions
            .do { self.scheduler.advance() },
            /// Make sure expected action is received and it modifies the state
            .receive(Portfolio.Action.didLoad(funds)) {
                $0.funds = .loaded(funds.map(Fund.State.init))
            },
            /// Test if routing actions modify the state
            .send(.handle(.fund(fund: .fixture()))) {
                $0.selectedFund = Fund.fixture() |> Fund.State.init
            },
            .send(.fund(action: .dismiss)) {
                $0.selectedFund = nil
            }
        )
    }
}
