//
//  SignUpRouter.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

enum SignUpEndpoint: APIConfigurable {

    /// Initialize registration session
    case initialize(email: String, password: String, firstName: String, lastName: String)


    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .initialize:
            return .post
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .initialize:
            return "sign_up/init"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .initialize:
            return [
                Defaults.APIParameterKey.email: "qwerty@gmail.com",
                Defaults.APIParameterKey.lastName: "Super_lastName",
                Defaults.APIParameterKey.telephone: "+380975305496",
                Defaults.APIParameterKey.firstName: "Very_first_name"
            ]
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Defaults.ProductionServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

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
