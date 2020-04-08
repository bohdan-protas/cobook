//
//  Optional + Extensions.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let collection):
            return collection.isEmpty
        }
    }
}
