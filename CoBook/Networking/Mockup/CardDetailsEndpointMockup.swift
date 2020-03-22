//
//  CardDetailsEndpointMockup.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CardEndpointMockup: EndpointMockup {

    case details

    var mockupFileName: String? {
        return "CardDetails"
    }

    var mockupFileExtension: String? {
        return "json"
    }


}
