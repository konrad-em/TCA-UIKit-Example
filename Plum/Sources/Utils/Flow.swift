import UIKit

public protocol Flow {
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func replace(with viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func dismissToRoot(animated: Bool, completion: (() -> Void)?)
    
    var presentedViewController: UIViewController? { get }
}

public extension Flow {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func replace(_ viewController: UIViewController) {
        replace(with: viewController, animated: true)
    }
}

// MARK: NavigationFlow

extension UINavigationController {
    public var navigationFlow: Flow {
        NavigationFlow(navigationController: self)
    }

    public struct NavigationFlow: Flow {
        public var presentedViewController: UIViewController? {
            navigationController?.topViewController
        }
        
        public func dismissToRoot(animated: Bool, completion: (() -> Void)?) {
            DispatchQueue.main.async {
                navigationController?.popToRootViewController(animated: animated)
                completion?()
            }
        }
        
        private weak var navigationController: UINavigationController?

        fileprivate init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }

        public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            navigationController?.pushViewController(viewController, animated: animated)
            completion?()
        }

        public func replace(with viewController: UIViewController, animated: Bool) {
            navigationController?.setViewControllers([viewController], animated: animated)
        }

        public func dismiss(animated: Bool, completion: (() -> Void)?) {
            navigationController?.popViewController(animated: animated)
            completion?()
        }
    }
}

// MARK: ModalFlow

extension UIViewController {
    public var modalFlow: Flow {
        ModalFlow(viewController: self)
    }

    private struct ModalFlow: Flow {
        var presentedViewController: UIViewController? {
            viewController?.presentedViewController
        }
        
        func dismissToRoot(animated: Bool, completion: (() -> Void)?) {
            dismiss(animated: animated, completion: completion)
        }
        
        private weak var viewController: UIViewController?

        fileprivate init(viewController: UIViewController) {
            self.viewController = viewController
        }

        public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            self.viewController?.present(viewController, animated: animated, completion: completion)
        }

        func replace(with viewController: UIViewController, animated: Bool) {
            present(viewController, animated: true, completion: nil)
        }

        public func dismiss(animated: Bool, completion: (() -> Void)?) {
            guard let viewController = viewController else { return }
            DispatchQueue.main.async {
                if viewController.presentedViewController == nil {
                    completion?()
                } else {
                    viewController.dismiss(animated: animated, completion: completion)
                }
            }
        }
    }
}

// MARK: TabsFlow

public struct TabsFlow {
    private weak var tabBarController: UITabBarController?
    
    fileprivate init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    public func select(at index: Int) {
        tabBarController?.selectedIndex = index
        tabBarController?.navigationItem.title = tabBarController?.viewControllers?[index].navigationItem.title
    }
}

public extension UITabBarController {
    var tabsFlow: TabsFlow {
        TabsFlow(tabBarController: self)
    }
}
