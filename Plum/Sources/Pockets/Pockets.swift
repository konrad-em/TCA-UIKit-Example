import ComposableArchitecture
import UIKit
import Utils
import Combine

public typealias Store = ComposableArchitecture.Store<State, Action>

public struct State: Equatable {
    public init() { }
}

public enum Action: Equatable {
    case dismiss
}

public struct Environment {
    public init() { }
}

public let reducer: Reducer<State, Action, Environment> = .empty

public func make(store: Store) -> UIViewController {
    ViewController(store: store)
}

public final class ViewController: Utils.ViewController<State, Action> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        dismissed = { [weak self] in self?.viewStore.send(.dismiss) }
        view.backgroundColor = .systemGreen
        navigationItem.title = "Pockets"
    }
}
