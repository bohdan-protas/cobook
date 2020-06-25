//
//  ContentManagerRouter.swift
//  CoBook
//
//  Created by protas on 3/18/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ContentManagerEndpoint: EndpointConfigurable {

    case singleFileUpload

    var useAuthirizationToken: Bool {
        return true
    }

    var baseUrlPath: URLComponents {
        var components = Constants.API.baseURLPath
        components.path = Constants.API.Path.contentManager.rawValue
        return components
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/upload/single"
    }

    var bodyParameters: Parameters? {
        return nil
    }

}
