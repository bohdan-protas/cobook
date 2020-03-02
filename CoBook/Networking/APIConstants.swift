//
//  Constants.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum APIConstants {

    static var baseURLPath: URLComponents {
        get {
            var components = URLComponents()
            components.scheme   = "https"
            components.host     = "3.124.214.212"
            components.path     = "/api/v1"
            return components
        }
    }

    enum ParameterKey {
        static let password     = "password"
        static let email        = "email"
        static let firstName    = "first_name"
        static let lastName     = "last_name"
        static let telephone    = "telephone"
        static let token        = "s_id"
        static let code         = "code"
        static let login        = "login"
        static let refreshToken = "refresh_token"
    }


}

enum ContentType: String {
    case json = "application/json"
    case xFormUrlencoded = "application/x-www-form-urlencoded"
}
