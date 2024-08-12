import UIKit

class ApplicationConfiguration: ApplicationConfigurable {
    var window: UIWindow?
    var appConfig: AppConfig!

    func setupSpecificConfig() {
        self.setupDefaultConfiguration()
    }

    func shutDown() {}

    func applicationRoute(from window: UIWindow) {
        self.window = window
        let mainNavigation = UINavigationController(rootViewController: HomeViewController())
        mainNavigation.isNavigationBarHidden = true
        setRoot(window: window, view: mainNavigation)
    }

    private func setupDefaultConfiguration() { }

    func setupFromRemoteConfig(completion: @escaping ((Bool) -> Void)) {}

    func toTabbar() {
        guard let window = self.window else { return }
        let mainNavigation = UINavigationController(rootViewController: MainTabbarViewController())
        mainNavigation.isNavigationBarHidden = true
        setRoot(window: window, view: mainNavigation)
    }
}
