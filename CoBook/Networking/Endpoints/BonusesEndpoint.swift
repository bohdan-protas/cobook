//
//  BonusesEndpoint.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum BonusesEndpoint: EndpointConfigurable {
    
    case getCardBonusesStats
    
    var useAuthirizationToken: Bool {
        return true
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .getCardBonusesStats:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getCardBonusesStats:
            return "/bonuses/card_bonuses"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        default: return nil
        }
    }
    
}
