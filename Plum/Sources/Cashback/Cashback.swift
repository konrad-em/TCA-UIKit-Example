import ComposableArchitecture
import Combine
import UIKit
import Utils

public typealias Store = ComposableArchitecture.Store<State, Action>

public struct State: Equatable {    
    public init() { }
}

public enum Action: Equatable { }

public struct Environment {
    public init() { }
}

public let reducer: Reducer<State, Action, Environment> = .empty

public func make(store: Store) -> UIViewController {
    ViewController(store: store)
}

final class ViewController: Utils.ViewController<State, Action> {
    override func didMove(toParent parent: UIViewController?) {
        view.backgroundColor = .systemPink
        tabBarItem = .init(
            title: "Cashback",
            image: UIImage(systemName: "bag.badge.plus")?.withRenderingMode(.alwaysTemplate),
            tag: 2
        )
        navigationItem.title = "Cashback"
    }
}
