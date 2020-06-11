//
//  MockupRouter.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

protocol EndpointMockup: URLRequestConvertible {
    var mockupFileName: String? { get }
    var mockupFileExtension: String? { get }
}

extension EndpointMockup {

    func asURLRequest() throws -> URLRequest {
        // Base URL

        let url = Bundle.main.url(forResource: mockupFileName, withExtension: mockupFileExtension)
        var urlRequest = URLRequest(url: url!)

        // HTTP Method
        urlRequest.httpMethod = HTTPMethod.get.rawValue

        /// Common Headers
        urlRequest.headers.add(.contentType(Constants.API.ContentType.json.rawValue))

        return urlRequest
    }


}
