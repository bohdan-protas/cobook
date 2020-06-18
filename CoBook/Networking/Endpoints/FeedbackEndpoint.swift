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
        
    var useAuthirizationToken: Bool {
        return true
    }
    
    var path: String {
        switch self {
        case .createFeedback:
            return "/cards/business/feedback"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createFeedback:
            return .post
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .createFeedback(let params):
            return params.dictionary
        }
    }
    
    
}
