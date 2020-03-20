//
//  APIConfiguration.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

protocol Endpoint: URLRequestConvertible {
    var useAuthirizationToken: Bool { get }
    var method: HTTPMethod { get }
    var baseUrlPath: URLComponents { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension Endpoint {
    var baseUrlPath: URLComponents {
        return APIConstants.baseURLPath
    }
}

// MARK: - Base configuration
extension Endpoint {

    func asURLRequest() throws -> URLRequest {
        // Base URL
        let url = try baseUrlPath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        /// Common Headers
        urlRequest.headers.add(.contentType(ContentType.json.rawValue))
        urlRequest.headers.add(.init(name: "locale", value: "UKR"))

        if useAuthirizationToken {
            urlRequest.headers.add(.authorization(bearerToken: AppStorage.Auth.accessToken ?? ""))
        }

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
    
}
