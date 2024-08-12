import UIKit

struct AppConfig: Codable {}

protocol ApplicationConfigurable {
    var window: UIWindow? { get set }
    var appConfig: AppConfig! { get set }

    func applicationRoute(from: UIWindow)
    func setupSpecificConfig()
    func setupFromRemoteConfig(completion: @escaping ((Bool) -> Void))
    func setRoot(window: UIWindow, view: UIViewController)
    func shutDown()
    func toTabbar()
}

extension ApplicationConfigurable {
    func setRoot(window: UIWindow, view: UIViewController) {
        UIView.transition(with: window, duration: 0.22, options: .transitionFlipFromRight, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = view
            UIView.setAnimationsEnabled(oldState)
        })
    }
}
