//
//  RequestParameters.swift
//  CoBook
//
//  Created by protas on 5/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol PaginableRequestParameters {
    var limit: Int? { get set }
    var offset: Int? { get set }
}

enum APIRequestParameters {

    // Card

    enum Card {


    }

    // MARK: - Services

    enum Services {

        struct List: Encodable, PaginableRequestParameters {
            var cardID: Int
            var limit: Int?
            var offset: Int?
        }

    }

    // MARK: - UsersEndpoint

    enum User {

        struct Search: Encodable {
            var search: String?
            var limit: Int?
            var offset: Int?
        }

        struct List: Encodable, PaginableRequestParameters {
            var cardID: Int
            var limit: Int?
            var offset: Int?
        }

    }



}




