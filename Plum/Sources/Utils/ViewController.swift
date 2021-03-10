import UIKit
import Combine
import ComposableArchitecture

public protocol Dismissable {
    var dismissed: () -> Void { get set }
}

open class ViewController<State: Equatable, Action>: UIViewController, Dismissable {
    open var dismissed: () -> Void = { }
    public var cancellables: Set<AnyCancellable> = []
    
    public var store: Store<State, Action>
    public lazy var viewStore: ViewStore<State, Action> = .init(store)
    
    public init(store: Store<State, Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            dismissed()
        }
    }
}
