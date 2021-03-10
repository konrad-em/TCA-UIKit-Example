import UIKit
import Combine
import ComposableArchitecture

final class TabBarController: UITabBarController {
    var cancellables: Set<AnyCancellable> = []
    
    private var store: Store
    private lazy var viewStore: ViewStore<State, Action> = .init(store)
    
    init(store: Store) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func tabBar(
        _ tabBar: UITabBar,
        didSelect item: UITabBarItem
    ) {
        navigationItem.title = viewControllers?[item.tag].navigationItem.title
    }
    
    override func setViewControllers(
        _ viewControllers: [UIViewController]?,
        animated: Bool
    ) {
        super.setViewControllers(viewControllers, animated: animated)
        navigationItem.title = viewControllers?[selectedIndex].navigationItem.title
    }
}
