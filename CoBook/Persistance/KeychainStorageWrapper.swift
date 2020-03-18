//
//  KeychainStorage.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

@propertyWrapper
struct KeychainStringValueStorageWrapper {
    let key: String
    let defaultValue: String?
    var storage: KeychainWrapper = KeychainWrapper.standard

    var wrappedValue: String? {
        get {
            let value = storage.string(forKey: key)
            return value ?? defaultValue
        }
        set {
            if let value = newValue {
                storage.set(value, forKey: key)
            } else {
                storage.removeObject(forKey: key)
            }
        }
    }
}
