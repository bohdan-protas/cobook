//
//  ProfileEndpoint.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ProfileEndpoint: Endpoint {

    case profile

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/profile"
    }

    var parameters: Parameters? {
        return nil
    }


}
