//
//  ContentManagerRouter.swift
//  CoBook
//
//  Created by protas on 3/18/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ContentManagerEndpoint: Endpoint {

    case singleFileUpload

    var useAuthirizationToken: Bool {
        return true
    }

    var baseUrlPath: URLComponents {
        var components = APIConstants.baseURLPath
        components.path = APIConstants.Path.contentManager.rawValue
        return components
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/upload/single"
    }

    var parameters: Parameters? {
        return nil
    }

}
