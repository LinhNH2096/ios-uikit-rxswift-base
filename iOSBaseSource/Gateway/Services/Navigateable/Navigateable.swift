import UIKit

protocol Navigateable {
    var viewController: UIViewController? { get }
    func push(to viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func pop(to viewController: UIViewController, animated: Bool)
    func popToRoot(animated: Bool)
    func dissmissViewController(animated flag: Bool, completion: (() -> Void)?)
    func disableSwipePopViewController()
    func enableSwipePopViewController()
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
}

extension Navigateable {
    func push(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    func pop(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.popToViewController(viewController, animated: animated)
    }
    func pop(animated: Bool = true) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    func popToRoot(animated: Bool = true) {
        self.viewController?.navigationController?.popToRootViewController(animated: animated)
    }
    func dissmissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: flag, completion: completion)
    }
    func disableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    func enableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func hideNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func showNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension Navigateable where Self: UIViewController {
    var viewController: UIViewController? {
        return self
    }
}
