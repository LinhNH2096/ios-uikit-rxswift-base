import Swinject
import IQKeyboardManagerSwift

extension Container {
    static var `default` = Container()
}

class ServiceFacade {
    static let applicationService: ApplicationConfigurable = ApplicationConfiguration()
    static let languageKeeper: LanguageKeepable = LanguageKeeper()
    static let persistentUserDefault: PersistentDataSaveable = UserDefaultsDataSaver()
    static func registerDefaultService(from windown: UIWindow) {
        ServiceFacade.initializeService(from: windown)
    }
    static func getService<T>(_ type: T.Type) -> T? {
        return Container.default.resolve(type)
    }
    static private func initializeService(from window: UIWindow) {
        applicationService.setupSpecificConfig()

        Container.default.register(LanguageKeepable.self) { (_) -> LanguageKeepable in
            return ServiceFacade.languageKeeper
        }
        Container.default.register(PersistentDataSaveable.self) { (_) -> PersistentDataSaveable in
            return ServiceFacade.persistentUserDefault
        }
        Container.default.register(ApplicationConfigurable.self) { (_) -> ApplicationConfigurable in
            return ServiceFacade.applicationService
        }
        configureKeyboard()
        setupNavigationBarAppearance()
    }
    static func shutDownAllService() {
        applicationService.shutDown()
    }
    static func configureKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = languageKeeper.getText(ofKey: "DONE")
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }

    static func setupNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = AppColor.appBackground
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: AppFont.roboto(name: .bold, size: 16),
                                                       NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
