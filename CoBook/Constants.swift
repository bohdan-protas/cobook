//
//  Constants.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import CoreLocation

enum Constants {

    enum API {

        static var baseURLPath: URLComponents {
            get {
                var components = URLComponents()
                components.scheme   = "https"
                components.host     = Host.dev.rawValue
                components.path     = Path.api.rawValue
                return components
            }
        }

        enum Host: String {
            case prod = "api.cobook.app"
            case dev = "dev.api.cobook.app"
        }

        enum Path: String {
            case api                = "/api/v1"
            case contentManager     = "/cm/v1"
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

        enum ContentType: String {
            case json = "application/json"
            case urlEncoded = "application/x-www-form-urlencoded"
        }

        static let additionalAcceptableImageContentTypes: Set<String> = [
            "image/*"
        ]

    }

    // MARK: - CoBook

    enum CoBook {
        static let appstoreID: String = "1509531412"
        static let faqURL: URL = "https://cobook.app/#faq"
        static let termsAndConditionsURL: URL = "https://cobook.app/website_terms_of_use"
        static let licenseURL: URL = "https://cobook.app/license"
        static let privacyPolicyURL: URL = "https://cobook.app/privacy_policy"
        static let logoURL: URL = "https://static.tildacdn.com/tild3930-3864-4365-b137-343937626266/logofuter.png"
    }

    // MARK: - StaticMapConstants

    enum StaticMap {
        static let baseURL = "https://maps.googleapis.com/maps/api/staticmap?"
        static let businessCardMarkerURL = "https://s3.eu-central-1.amazonaws.com/cobook.attachments/static/personal.png"
        static let personalCardMarkerURL = "https://s3.eu-central-1.amazonaws.com/cobook.attachments/static/Group.png"
    }

    // MARK: - GoogleConstants

    enum Google {

        static let placesApiKey: String = "AIzaSyDLbwSAzqZY0085ClTgTuxvFEt-Tg672qk"

        enum DirectionMode: String {
            case driving
            case transit
            case bicycling
            case walking
        }

        static func googleMapsRouteURL(saddr: CLLocationCoordinate2D? = nil, daddr: CLLocationCoordinate2D? = nil, directionMode: DirectionMode) -> URL? {
            var routeURLPath: String = "https://www.google.com/maps/dir/?api=1"

            routeURLPath.append("&origin=")
            if let saddr = saddr {
                routeURLPath.append("\(saddr.latitude),\(saddr.longitude)")
            }

            routeURLPath.append("&destination=")
            if let daddr = daddr {
                routeURLPath.append("\(daddr.latitude),\(daddr.longitude)")
            }

            routeURLPath.append("&travelmode=\(directionMode.rawValue)")
            return URL.init(string: routeURLPath)
        }

    }

    // MARK: - Dynamic link

    enum DynamicLinks {

        static var baseURLPath: URLComponents {
            get {
                var components = URLComponents()
                components.scheme   = "https"
                components.host     = "cobook.app"
                return components
            }
        }

        static let domainURIPrefix: URL = "https://dev.share.cobook.app/link"

        enum Path: String {
            case personalCard = "/personal_card"
            case businessCard = "/business_card"
            case article = "/article"
            case download = "/download"
        }

        enum QueryName: String {
            case id
            case articleID = "article_id"
            case albumID = "album_id"
            case shareableUserID = "shareable_user_id"
        }

    }

    // MARK: - Android

    enum Android {
        static let packageName: String = "com.cobook.cobook"
    }

}


