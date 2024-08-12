//
//  CommonUltils.swift
//  iOSBaseSource
//

import UIKit

class CommonUtils {
    static let shared = CommonUtils()

    private let persistentDataSaveable = ServiceFacade.getService(PersistentDataSaveable.self) // UserDefault

    var isFirstLaunch: Bool {
        get {
            if let logged = ServiceFacade.persistentUserDefault.getItem(fromKey: UserDefaultKey.isFirstLaunch.rawValue) as? Bool {
                return logged
            }
            return false
        }

        set {
            ServiceFacade.persistentUserDefault.set(item: newValue,
                                                    toKey: UserDefaultKey.isFirstLaunch.rawValue)
        }
    }

    var createdDateFormat: DateFormat {
        switch ServiceFacade.languageKeeper.getCurrentLanguage().name {
        case .enLanguage:
            return .dateHourMinute2
        case .viLanguage:
            return .dateHourMinute3
        }
    }

}
