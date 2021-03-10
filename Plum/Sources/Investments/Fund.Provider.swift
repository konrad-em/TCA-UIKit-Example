import Combine
import Foundation

public struct FundsProvider {
    var load: () -> AnyPublisher<[Fund], Never>
}

extension FundsProvider {
    public static let live = Self {
        let funds = PassthroughSubject<[Fund], Never>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            funds.send(
                [
                    Fund(name: "Balanced Bundle"),
                    Fund(name: "Slow & Steady"),
                    Fund(name: "Growth Stack"),
                    Fund(name: "American Dream"),
                    Fund(name: "Best of British"),
                ]
            )
        }
        return funds.eraseToAnyPublisher()
    }
}
