//
//  NSError + Extensions.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

extension NSError {

    static func instantiate(code: Int, localizedMessage: String, domain: String = "com.cobook.error") -> NSError {
        let error = NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedMessage])
        return error
    }
}
