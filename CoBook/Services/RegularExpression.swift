//
//  RegularExpression.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum RegexPattern: String {
    case email      = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case telephone  = ""
    case password   = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{5,}$"
}

struct RegularExpression: ExpressibleByStringLiteral {
    private let regex: NSRegularExpression

    init(regex: NSRegularExpression) {
        self.regex = regex
    }

    init(stringLiteral value: String) {
        do {
            let regex = try NSRegularExpression(pattern: value, options: [])
            self.init(regex: regex)
        } catch {
            preconditionFailure("Illegal regular expression: \(value).")
        }
    }

    init(pattern: RegexPattern) {
        self.init(stringLiteral: pattern.rawValue)
    }

    func match(in string: String) -> Bool {
        return regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
    }
}
