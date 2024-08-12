import UIKit

enum LanguageNameSupported: String {
    case english = "English"
    case vietnamese = "Việt Nam"
}

enum LanguageSupported: String, CaseIterable {
    case enLanguage = "en"
    case viLanguage = "vi"
    
    var buttonTag: Int {
        switch self {
        case .enLanguage: return 1
        case .viLanguage: return 2
        }
    }

    static func getLanguageSupported(buttonTag: Int) -> LanguageSupported {
        return LanguageSupported.allCases.first(where: { $0.buttonTag == buttonTag }) ?? .enLanguage
    }

    static func convertToHumanreadable(languageCode: LanguageSupported) -> String {
        switch languageCode {
        case .enLanguage:
            return LanguageNameSupported.english.rawValue
        case .viLanguage:
            return LanguageNameSupported.vietnamese.rawValue
        }
    }
    static func convertToCode(languageText: String) -> String {
        switch languageText {
        case LanguageNameSupported.vietnamese.rawValue:
            return LanguageSupported.viLanguage.rawValue
        default:
            return LanguageSupported.enLanguage.rawValue
        }
    }
}

class LanguageSetting: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    var name: LanguageSupported = .enLanguage
    init(name languageName: LanguageSupported = .enLanguage) {
        self.name = languageName
    }
    func getInternationalCode() -> String {
        return self.name.rawValue
    }
    static func getDefaultLanguage() -> LanguageSetting {
        return LanguageSetting(name: .enLanguage)
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.name.rawValue, forKey: "name")
    }
    required convenience init?(coder: NSCoder) {
        let nameAsString = coder.decodeObject(forKey: "name") as? String ?? ""
        let language = LanguageSupported.allCases.first(where: {$0.rawValue == nameAsString}) ?? .enLanguage
        self.init(name: language)
    }
}
struct LanguageKeeperConst {
    static let keySaveLanguageCode = "keySaveLanguageCode"
}
protocol LanguageKeepable {
    func hasBeenSet() -> Bool
    func getCurrentLanguage() -> LanguageSetting
    func setCurrentLanguage(to language: LanguageSetting)
    func getText(ofKey key: String) -> String
    func addItemForObserver(control: NSObject)
}
