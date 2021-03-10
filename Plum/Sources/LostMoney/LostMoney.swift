import ComposableArchitecture
import UIKit
import Utils
import Combine

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
        view.backgroundColor = .systemOrange
        tabBarItem = .init(
            title: "Lost Money",
            image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate),
            tag: 1
        )
        navigationItem.title = "Lost Money"
    }
}
