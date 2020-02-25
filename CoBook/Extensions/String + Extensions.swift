//
//  String + Extensions.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - Localization helper
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
