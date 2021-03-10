import ComposableArchitecture
import Utils
import UIKit
import Combine

extension Fund {
    static func make(store: Store) -> UIViewController {
        ViewController(store: store)
    }
}

public struct Fund: Equatable {
    let name: String
}

extension Fund {
    typealias Store = ComposableArchitecture.Store<State, Action>

    struct State: Equatable {
        let fund: Fund
    }
    
    public enum Action: Equatable {
        case dismiss
    }

    struct Environment {
        public init() { }
    }

    static let reducer: Reducer<State, Action, Environment> = .empty
}

extension Fund {
    class ViewController: Utils.ViewController<State, Action> {
        private lazy var label: UILabel = {
            let view = UILabel()
            view.font = .boldSystemFont(ofSize: 16.0)
            view.textAlignment = .center
            view.backgroundColor = .systemGray5
            return view
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            dismissed = { [weak self] in self?.viewStore.send(.dismiss) }
            navigationItem.title = "Fund"
            view = label
            viewStore.publisher.fund.name
                .compactMap(identity)
                .assign(to: \.text, on: label)
                .store(in: &self.cancellables)
        }
    }
}
