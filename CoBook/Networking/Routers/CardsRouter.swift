//
//  CardsRouter.swift
//  CoBook
//
//  Created by protas on 3/16/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

enum CardsRouter: Router {

    case createPersonalCard(parameters: PersonalCardAPI.Request.CreationParameters)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .createPersonalCard:
            return "/cards/personal"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createPersonalCard(let parameters):
            return parameters.dictionary
        }
    }


}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


