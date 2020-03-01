//
//  UserDefaultsStorage.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - UserDefaultObjectStorage
@propertyWrapper
struct UserDefaultObjectStorage<Object: Codable> {
    let key: String
    let defaultValue: Object
    var storage: UserDefaults = .standard

    var wrappedValue: Object {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(Object.self, from: data)
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)

                // Set value to UserDefaults
                UserDefaults.standard.set(data, forKey: key)
            }
        }

    }
}

extension UserDefaultObjectStorage where Object: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

// MARK: - UserDefaultValueStorage
@propertyWrapper
struct UserDefaultValueStorage<Value> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
}

extension UserDefaultValueStorage where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}
