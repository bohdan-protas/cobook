//
//  NewsEndpoint.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum NewsEndpoint: EndpointConfigurable {
    
    case getNewsRecord(limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNewsRecord:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getNewsRecord:
            return "/news"
        }
    }
    
    var urlParameters: [String : String]? {
        switch self {
        case .getNewsRecord(let limit, let offset):
            var parameters: [String: String] = [:]
            parameters["limit"] = "\(limit ?? 15)"
            parameters["offset"] = "\(offset ?? 0)"
            return parameters
        }
    }
    
}
