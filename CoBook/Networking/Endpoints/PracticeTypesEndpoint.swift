//
//  PracticeTypesRouter.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum PracticeTypesEndpoint: Endpoint {

    /// Request localized list of practice types
    case list

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/practice_types/list"
    }

    var bodyParameters: Parameters? {
        return nil
    }


}
