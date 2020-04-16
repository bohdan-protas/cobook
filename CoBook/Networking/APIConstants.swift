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
            components.host     = "cobook.app"
            components.path     = Path.api.rawValue
            return components
        }
    }

    enum Path: String {
        case api                = "/api/v1"
        case contentManager     = "/cm/v1"
    }

    enum Google {
        static let placesApiKey: String = "AIzaSyDLbwSAzqZY0085ClTgTuxvFEt-Tg672qk"
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
        static let id           = "id"
    }

    static let additionalAcceptableImageContentTypes: Set<String> = [
        "image/*"
    ]

    enum ContentType: String {
        case json = "application/json"
        case xFormUrlencoded = "application/x-www-form-urlencoded"
    }

}


