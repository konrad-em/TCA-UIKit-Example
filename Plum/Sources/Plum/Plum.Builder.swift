import ComposableArchitecture
import Home
import LostMoney
import Cashback
import UIKit
import Utils

func make(
    store: Store,
    flow: Flow
) -> UIViewController {
    let viewController = TabBarController(store: store)

    viewController.setViewControllers(
        [
            Home.make(
                store: store.home,
                flow: flow
            ),
            LostMoney.make(store: store.lostMoney),
            Cashback.make(store: store.cashback)
        ],
        animated: false
    )
    
    ViewStore(store)
        .publisher.route
        .compactMap(identity)
        .sink(receiveValue: \.rawValue >>> viewController.tabsFlow.select)
        .store(in: &viewController.cancellables)

    return viewController
}

// Home

extension Store {
    var home: Home.Store {
        scope(
            state: \.home,
            action: Action.home
        )
    }
}

extension Home.Environment {
    init(environment: Environment) {
        self.init(mainQueue: environment.mainQueue)
    }
}

// Lost Money

extension Store {
    var lostMoney: LostMoney.Store {
        scope(
            state: \.lostMoney,
            action: Action.lostMoney
        )
    }
}

extension LostMoney.Environment {
    init(environment: Environment) {
        self.init()
    }
}

// Cashback

extension Store {
    var cashback: Cashback.Store {
        scope(
            state: \.cashback,
            action: Action.cashback
        )
    }
}

extension Cashback.Environment {
    init(environment: Environment) {
        self.init()
    }
}
