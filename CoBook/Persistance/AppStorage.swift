//
//  AppData.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - AppStorage
enum AppStorage {

    enum Keys: String {
        case isTutorialSeen
        case userCompletedRegistration
        case userInitiatedRegistration
        case accessToken
        case refreshToken
        case profile
        case firstAppLaunch
        case isNeedToUpdateAccountData
    }

    enum State {
        @UserDefaultValueStorageWrapper(key: Keys.firstAppLaunch.rawValue, defaultValue: true)
        static var isFirstAppLaunch: Bool

        @UserDefaultValueStorageWrapper(key: Keys.isNeedToUpdateAccountData.rawValue, defaultValue: false)
        static var isNeedToUpdateAccountData: Bool
    }

    enum User {
        @UserDefaultValueStorageWrapper(key: Keys.isTutorialSeen.rawValue, defaultValue: false)
        static var isTutorialShown: Bool

        @UserDefaultValueStorageWrapper(key: Keys.userInitiatedRegistration.rawValue, defaultValue: false)
        static var isUserInitiatedRegistration: Bool

        @UserDefaultValueStorageWrapper(key: Keys.userCompletedRegistration.rawValue, defaultValue: false)
        static var isUserCompletedRegistration: Bool

        @UserDefaultObjectStorageWrapper(key: Keys.profile.rawValue, defaultValue: ProfileApiModel())
        static var profile: ProfileApiModel?
    }

    enum Auth {
        @KeychainStringValueStorageWrapper(key: Keys.accessToken.rawValue, defaultValue: nil, storage: KeychainWrapper.auth)
        static var accessToken: String?

        @KeychainStringValueStorageWrapper(key: Keys.refreshToken.rawValue, defaultValue: nil, storage: KeychainWrapper.auth)
        static var refreshToken: String?

        static func deleteAllData() {
            KeychainWrapper.auth.removeAllKeys()
        }
    }

    static func deleteAllData() {
        KeychainWrapper.auth.removeAllKeys()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

}


