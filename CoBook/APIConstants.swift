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
            components.host     = "cobook.app"
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
        case xFormUrlencoded = "application/x-www-form-urlencoded"
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
            var routeURLPath: String = "comgooglemaps://?"

            routeURLPath.append("&saddr=")
            if let saddr = saddr {
                routeURLPath.append("\(saddr.latitude),\(saddr.longitude)")
            }

            routeURLPath.append("&daddr=")
            if let daddr = daddr {
                routeURLPath.append("\(daddr.latitude),\(daddr.longitude)")
            }

            routeURLPath.append("&directionsmode=\(directionMode.rawValue)")
            return URL.init(string: routeURLPath)
        }
    }

    // MARK: - StaticMap

    enum StaticMap {
        static let baseURL = "https://maps.googleapis.com/maps/api/staticmap?"
        static let markerURL = "https://s3.eu-central-1.amazonaws.com/cobook.attachments/static/personal.png"
    }

    // MARK: - Helpers

    static let additionalAcceptableImageContentTypes: Set<String> = [
        "image/*"
    ]


}


