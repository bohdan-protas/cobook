//
//  APIConfiguration.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

protocol EndpointConfigurable: URLRequestConvertible {
    var useAuthirizationToken: Bool { get }
    var method: HTTPMethod { get }
    var baseUrlPath: URLComponents { get }
    var path: String { get }
    var urlParameters: [String: String]? { get }
    var bodyParameters: Parameters? { get }
}

extension EndpointConfigurable {
    var baseUrlPath: URLComponents {
        return Constants.API.baseURLPath
    }

    var urlParameters: [String: String]? { return nil }
    var bodyParameters: Parameters? { return nil }
}

// MARK: - Base configuration

extension EndpointConfigurable {

    func asURLRequest() throws -> URLRequest {

        // Base URL
        let url = try baseUrlPath.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        /// Common Headers
        urlRequest.headers.add(.contentType(Constants.API.ContentType.json.rawValue))

        let currentDeviceLanguage = NSLocale.current.languageCode
        let apiLanguageCode = APILanguageCode.init(deviceLanguageCode: currentDeviceLanguage)
        urlRequest.headers.add(.init(name: "locale", value: apiLanguageCode.rawValue))

        if useAuthirizationToken, let accessToken = AppStorage.Auth.accessToken, !accessToken.isEmpty  {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }

        // URL parameters encoding
        if let urlParameters = urlParameters {
            do {
                let encoder = URLEncodedFormParameterEncoder(destination: URLEncodedFormParameterEncoder.Destination.queryString)
                urlRequest = try encoder.encode(urlParameters, into: urlRequest)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        // Body parameters encoding
        if let parameters = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
    
}
