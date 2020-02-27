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
        case userCompletedTutorial
        case userCompletedRegistration
        case userInitiatedRegistration
        case accessToken
        case refreshToken
        case profile
    }

    @UserDefaultValueStorage(key: Keys.userInitiatedRegistration.rawValue, defaultValue: false)
    static var isUserCompletedTutorial: Bool

    @UserDefaultValueStorage(key: Keys.userInitiatedRegistration.rawValue, defaultValue: false)
    static var isUserInitiatedRegistration: Bool

    @UserDefaultValueStorage(key: Keys.userCompletedRegistration.rawValue, defaultValue: false)
    static var isUserCompletedRegistration: Bool

    @KeychainStringValueStorage(key: Keys.accessToken.rawValue, defaultValue: nil, storage: KeychainWrapper.auth)
    static var accessToken: String?

    @KeychainStringValueStorage(key: Keys.refreshToken.rawValue, defaultValue: nil, storage: KeychainWrapper.auth)
    static var refreshToken: String?

    @UserDefaultObjectStorage(key: Keys.profile.rawValue, defaultValue: Profile())
    static var profile: Profile?

    static func deleteAllData() {
        KeychainWrapper.auth.removeAllKeys()
        UserDefaults.standard.removePersistentDomain(forName:  Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

}


