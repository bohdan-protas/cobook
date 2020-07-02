//
//  CardDetailsEndpointMockup.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CardEndpointMockup: EndpointMockupConfigurable {

    case details

    var mockupFileName: String? {
        return "CardDetails"
    }

    var mockupFileExtension: String? {
        return "json"
    }


}

enum BonusesEndpointMockup: EndpointMockupConfigurable {

    case getCardBonusesIncoms

    var mockupFileName: String? {
        return "BonuseIncoms"
    }

    var mockupFileExtension: String? {
        return "json"
    }


}
