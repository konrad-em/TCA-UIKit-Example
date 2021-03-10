import ComposableArchitecture
import Investments
import Pockets
import Combine
import Utils

public enum Route {
    case investments
    case pockets
    
    static func investments(
        with store: Store,
        in flow: Flow
    ) -> Cancellable {
        store
            .scope(
                state: \.investmentsPortfolio,
                action: Action.investmentsPortfolio
            )
            .ifLet(
                then: { store in
                    Portfolio.make(
                        store: store,
                        flow: flow
                    ) |> flow.present
                },
                else: {
                    guard let viewController = flow.presentedViewController as? Portfolio.ViewController else { return }
                    viewController.dismissed = { }
                    flow.dismiss(animated: true, completion: nil)
                }
            )
    }
    
    static func pockets(
        with store: Store,
        in flow: Flow
    ) -> Cancellable {
        store
            .scope(
                state: \.pockets,
                action: Action.pockets
            )
            .ifLet(
                then: Pockets.make >>> flow.present,
                else: {
                    guard let viewController = flow.presentedViewController as? Pockets.ViewController else { return }
                    viewController.dismissed = { }
                    flow.dismiss(animated: true, completion: nil)
                }
            )
    }
}
