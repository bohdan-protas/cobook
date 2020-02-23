//
//  Constants.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct Defaults {

    struct ProductionServer {
        static let baseURL = "https://3.124.214.212/api/v1"
    }

    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let telephone = "telephone"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case xFormUrlencoded = "application/x-www-form-urlencoded"
}
