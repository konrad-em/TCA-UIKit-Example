import UIKit
import Utils
import ComposableArchitecture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    
    private lazy var navigationController = UINavigationController()
    private lazy var viewStore = ViewStore(store)
    private lazy var store: Plum.Store = .init(
        initialState: .init(
            home: .init(),
            lostMoney: .init(),
            cashback: .init()
        ),
        reducer: reducer.debug(),
        environment: .init(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        navigationController.navigationFlow.replace(
            Plum.make(
                store: store,
                flow: navigationController.navigationFlow
            )
        )
        
        return true
    }
}
