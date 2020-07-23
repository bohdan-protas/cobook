//
//  PropertyWrappers.swift
//  CoBook
//
//  Created by protas on 6/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


@propertyWrapper
struct Trimmed {
    private(set) var value: String = ""

    var wrappedValue: String {
        get { return value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
}
