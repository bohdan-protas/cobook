//
//  FeedbackEndpoint.swift
//  CoBook
//
//  Created by Bogdan Protas on 18.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum FeedbackEndpoint: Endpoint {
     
    case createFeedback(parameters: APIRequestParameters.Feedback.Create)
    case list(parameters: APIRequestParameters.Feedback.List)
    
    var useAuthirizationToken: Bool {
        return true
    }
    
    var path: String {
        switch self {
        case .createFeedback:
            return "/cards/business/feedback"
        case .list:
            return "/cards/business/feedback"
        }
    }
    
    var method: HTTPMethod {
        switch self {
    
        case .createFeedback:
            return .post
        case .list:
            return .get
        }
    }
    
    var urlParameters: [String : String]? {
        switch self {
        case .list(let params):
            var parameters: [String: String] = [:]
            if let albumID = params.id {
                parameters["card_id"] = "\(albumID)"
            }
            if let limit = params.limit {
                parameters["limit"] = "\(limit)"
            }
            if let offset = params.offset {
                parameters["offset"] = "\(offset)"
            }
            return parameters
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .createFeedback(let params):
            return params.dictionary
        default:
            return nil
        }
    }
    
    
}
