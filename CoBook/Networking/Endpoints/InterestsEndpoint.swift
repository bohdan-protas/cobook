//
//  InterestsRouter.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum InterestsEndpoint: Endpoint {

    /// Request localized list of interests
    case list

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/interests/list"
    }

    var bodyParameters: Parameters? {
        return nil
    }

    
}
