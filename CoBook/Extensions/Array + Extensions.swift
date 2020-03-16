//
//  Array + Extensions.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

extension Array {

    func indexIsValid(index: Index) -> Bool {
        return index >= 0 && index < count
    }

    subscript(safe index: Index) -> Element? {
        get {
            let isValidIndex = indexIsValid(index: index)
            return isValidIndex ? self[index] : nil
        }
        set {
            if indexIsValid(index: index), let value = newValue {
                self[index] = value
            }
        }

    }

    
}
