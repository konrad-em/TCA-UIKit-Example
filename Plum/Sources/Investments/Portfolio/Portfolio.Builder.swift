import ComposableArchitecture
import Utils
import UIKit
import Combine

extension Portfolio {
    public static func make(
        store: Store,
        flow: Flow
    ) -> UIViewController {
        let viewController = ViewController(store: store)
        
        Route
            .fund(with: store, in: flow)
            .store(in: &viewController.cancellables)
            
        return viewController
    }
}

extension Fund.Environment {
    init(environment: Portfolio.Environment) {
        self.init()
    }
}
