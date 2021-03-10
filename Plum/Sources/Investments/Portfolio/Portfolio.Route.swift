import Utils
import UIKit
import Combine
import ComposableArchitecture

extension Portfolio {
    public enum Route: Equatable {
        case fund(fund: Fund)

        static func fund(
            with store: Store,
            in flow: Flow
        ) -> Cancellable {
            store
                .scope(
                    state: \.selectedFund,
                    action: Action.fund
                )
                .ifLet(
                    then: Fund.make >>> flow.present,
                    else: {
                        guard let viewController = flow.presentedViewController as? Investments.Fund.ViewController else { return }
                        viewController.dismissed = { }
                        flow.dismiss(animated: true, completion: nil)
                    }
                )
        }
    }
}
