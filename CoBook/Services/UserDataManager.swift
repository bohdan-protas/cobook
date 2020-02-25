//
//  UserDataManager.swift
//  CoBook
//
//  Created by protas on 2/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

class UserDataManager {

    enum Keys: String, CaseIterable {
        case userID
        case accessToken
        case refreshToken
        case telephone
        case email
        case password
    }

    // MARK: Properties
    public static var `default`: UserDataManager = {
        let userDataManager = UserDataManager()
        return userDataManager
    }()

    // MARK: Initializer
    private init() {

    }

    var userID: String? {
        get {
            return UserDefaults.standard.value(forKey: Keys.userID.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userID.rawValue)
        }
    }

    var accessToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: Keys.accessToken.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.accessToken.rawValue)
            }
        }
    }

    var refreshToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.refreshToken.rawValue)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: Keys.refreshToken.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.refreshToken.rawValue)
            }
        }
    }

    var password: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.password.rawValue)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: Keys.password.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.password.rawValue)
            }
        }
    }

    var telephone: String? {
        get {
            return UserDefaults.standard.value(forKey: Keys.telephone.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.telephone.rawValue)
        }

    }

    var email: String? {
        get {
            return UserDefaults.standard.value(forKey: Keys.email.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.email.rawValue)
        }

    }

    func deleteData() {
        for key in Keys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }


}
