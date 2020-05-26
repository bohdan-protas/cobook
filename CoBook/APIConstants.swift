//
//  Constants.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import CoreLocation

enum APIConstants {

    // MARK: - Base

    static var baseURLPath: URLComponents {
        get {
            var components = URLComponents()
            components.scheme   = "https"
            components.host     = "dev.api.cobook.app"
            components.path     = Path.api.rawValue
            return components
        }
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

    // MARK: - Google

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

    // MARK: - StaticMap

    enum StaticMap {
        static let baseURL = "https://maps.googleapis.com/maps/api/staticmap?"
        static let businessCardMarkerURL = "https://s3.eu-central-1.amazonaws.com/cobook.attachments/static/personal.png"
        static let personalCardMarkerURL = "https://s3.eu-central-1.amazonaws.com/cobook.attachments/static/Group.png"
    }

    // MARK: - Helpers

    static let additionalAcceptableImageContentTypes: Set<String> = [
        "image/*"
    ]


}

// MARK: - Dynamic link

enum DynamicLinkConstants {

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


