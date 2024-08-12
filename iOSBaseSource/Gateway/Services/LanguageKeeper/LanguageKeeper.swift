import Swinject

class LanguageKeeper: LanguageKeepable {
    private var languageTexts: LanguageItemModel!
    private var localizeHolder = LocalizeHolder()
    private var dataSaverWorker: PersistentDataSaveable? {
        Container.default.resolve(PersistentDataSaveable.self)
    }

    init() {
        self.setDefaultLanguage()
        self.languageTexts = loadLanguageFileFromJson()
    }
    private func setDefaultLanguage() {
        /*guard !hasBeenSet() else { return }
        let language = Locale.preferredLanguages[0]
        print("[APP-LANG]: \(language)")
        if language.contains(LanguageSupported.viLanguage.rawValue) {
            self.setCurrentLanguage(to: LanguageSetting(name: .viLanguage))
        } else {
            self.setCurrentLanguage(to: LanguageSetting(name: .enLanguage))
        }*/

        self.setCurrentLanguage(to: LanguageSetting(name: .enLanguage))
    }
    func hasBeenSet() -> Bool {
        guard let dataSaverWorker = self.dataSaverWorker else { return false }
        let currentLanguageSetting = dataSaverWorker.getItem(fromKey: LanguageKeeperConst.keySaveLanguageCode)
        let isSettingExisted = (currentLanguageSetting != nil)
        return isSettingExisted
    }
    func getCurrentLanguage() -> LanguageSetting {
        guard let dataSaverWorker = self.dataSaverWorker else { return LanguageSetting.getDefaultLanguage() }
        let itemSaved = dataSaverWorker.getItem(fromKey: LanguageKeeperConst.keySaveLanguageCode)
        guard let currentLanguage = itemSaved as? LanguageSetting else {
            return LanguageSetting.getDefaultLanguage()
        }
        return currentLanguage
    }
    func setCurrentLanguage(to language: LanguageSetting) {
        guard let dataSaverWorker = self.dataSaverWorker else { return }
        dataSaverWorker.set(item: language, toKey: LanguageKeeperConst.keySaveLanguageCode)
        localizeHolder.reloadInfo()
    }
    func getText(ofKey key: String) -> String {
        guard let item = self.languageTexts.first(where: {$0.key == key}) else { return "" }
        let currentLanguageSetting = getCurrentLanguage().getInternationalCode()
        guard let result = item.getField(name: currentLanguageSetting) else { return "" }
        return result
    }
    func addItemForObserver(control: NSObject) {
        self.localizeHolder.add(item: control)
    }
}
extension LanguageKeeper {
    private func loadLanguageFileFromJson() -> LanguageItemModel {
        if let path = Bundle.main.path(forResource: "language", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let languageInformation = try? JSONDecoder().decode(LanguageItemModel.self, from: data) {
                    return languageInformation
                } else {
                    return []
                }
            } catch {
                return []
            }
        }
        return []
    }
}
