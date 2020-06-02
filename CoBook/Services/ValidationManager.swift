//
//  ValidadionManager.swift
//  CoBook
//
//  Created by protas on 2/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

class ValidationManager {

    enum Defaults {
        static let userNameLengthRange  = 3..<12
        static let passwordRange        = 6..<24
        static let professionTypeRange  = 3..<50
        static let activityDescrRange   = 3..<500
    }

    static func validate(firstName: String) -> String? {
        if !Defaults.userNameLengthRange.contains(firstName.utf16.count) {
            return "Error.Validation.firstName".localized
        }
        return nil
    }

    static func validate(lastName: String) -> String? {
        if !Defaults.userNameLengthRange.contains(lastName.utf16.count) {
            return "Error.Validation.lastName".localized
        }
        return nil
    }

    static func validate(telephone: String) -> String? {
        if !RegularExpression.init(pattern: .telephone).match(in: telephone) {
            return "Error.Validation.telephone".localized
        }
        return nil
    }

    static func validate(email: String) -> String? {
        if !RegularExpression.init(pattern: .email).match(in: email) {
            return "Error.Validation.email".localized
        }
        return nil
    }

    static func validate(password: String) -> String? {
        if !Defaults.passwordRange.contains(password.utf16.count) {
            return "Error.Validation.password".localized
        }
        return nil
    }

    static func validate(profession: String) -> String? {
        if !Defaults.professionTypeRange.contains(profession.utf16.count) {
            return "Error.Validation.profession".localized
        }
        return nil
    }

    static func validate(activityDescr: String) -> String? {
        if !Defaults.activityDescrRange.contains(activityDescr.utf16.count) {
            return "Error.Validation.activityDescr".localized
        }
        return nil
    }


}
