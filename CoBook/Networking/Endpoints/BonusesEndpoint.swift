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
    case getLeaderbordStats(params: APIRequestParameters.Bonuses.LeaderbordStats)
    case getReferalStats
    
    var useAuthirizationToken: Bool {
        return true
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCardBonusesStats:
            return .post
        case .getLeaderbordStats:
            return .post
        case .getReferalStats:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getCardBonusesStats:
            return "/bonuses/card_bonuses"
        case .getLeaderbordStats:
            return "/bonuses/leaderboard"
        case .getReferalStats:
            return "bonuses/referral_stats"
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getLeaderbordStats(let params):
            return params.dictionary
        default: return nil
        }
    }
    
}
