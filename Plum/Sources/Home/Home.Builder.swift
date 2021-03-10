import UIKit
import Investments
import Pockets
import Utils

public func make(
    store: Store,
    flow: Flow
) -> UIViewController {
    let viewController = ViewController(store: store)

    Route.investments(
        with: store,
        in: flow
    )
    .store(in: &viewController.cancellables)
    
    Route.pockets(
        with: store,
        in: viewController.modalFlow
    )
    .store(in: &viewController.cancellables)
    
    return viewController
}
     
// Investments

extension Investments.Portfolio.Environment {
    init(environment: Environment) {
        self.init(
            fundsProvider: FundsProvider.live,
            mainQueue: environment.mainQueue
        )
    }
}

// Pockets

extension Pockets.Environment {
    init(environment: Environment) {
        self.init()
    }
}
