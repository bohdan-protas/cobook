//
//  UserEndpoint.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum UsersEndpoint: Endpoint {

    case searchEmployee(searchQuery: String?, limit: Int?, offset: Int?)
    case employeeList(cardId: Int, limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .searchEmployee:
            return "users/employee/search"
        case .employeeList:
            return "users/employee/list"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .searchEmployee(let searchQuery, let limit, let offset):
            return [
                "search": searchQuery ?? "",
                "limit": limit ?? 15,
                "offset": offset ?? 0
            ]

        case .employeeList(let cardId, let limit, let offset):
            return [
                "card_id": cardId,
                "limit": limit ?? 15,
                "offset": offset ?? 0
            ]
        }
    }

    
}
