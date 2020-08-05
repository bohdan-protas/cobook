//
//  PricesEndpoint.swift
//  CoBook
//
//  Created by Bogdan Protas on 05.08.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum PricesEndpoint: EndpointConfigurable {
    
    case getPrices
    
    var useAuthirizationToken: Bool {
        return true
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/prices"
    }
    
}
