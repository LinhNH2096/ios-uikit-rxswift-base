import Security
import Foundation

protocol KeychainServiceable {
    func saveValue(_ value: String, forKey key: KeychainServiceKey) -> Bool
    func getValue(forKey key: KeychainServiceKey) -> String?
    func deleteValue(forKey key: KeychainServiceKey) -> Bool
}

enum KeychainServiceType: String {
    case passcode

    var attrServiceDesc: String {
        let bundleID = ConfigurationKey.bundleID.value() ?? "com.linhnguyen.finote"
        return bundleID + "." + self.rawValue + ".keychain"
    }
}

enum KeychainServiceKey: String {
    case passcode

    var desc: String {
        let bundleID = ConfigurationKey.bundleID.value() ?? "com.linhnguyen.finote"
        return bundleID + "." + self.rawValue
    }
}


class KeychainServiceImplement: KeychainServiceable {

    private let service: KeychainServiceType

    init(service: KeychainServiceType) {
        self.service = service
    }

    func saveValue(_ value: String, forKey key: KeychainServiceKey) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service.attrServiceDesc,
            kSecAttrAccount as String: key.desc,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary) // Delete existing item if it exists

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getValue(forKey key: KeychainServiceKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service.attrServiceDesc,
            kSecAttrAccount as String: key.desc,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            let value = String(data: retrievedData, encoding: .utf8)
            return value
        } else {
            return nil
        }
    }

    func deleteValue(forKey key: KeychainServiceKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service.attrServiceDesc,
            kSecAttrAccount as String: key.desc
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
