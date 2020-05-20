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

    enum Auth {

        struct Credentials: Encodable {
            var oldPassword: String?
            var newPassword: String?

            enum CodingKeys: String, CodingKey {
                case oldPassword = "old_password"
                case newPassword = "new_password"
            }
        }

    }

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

    // MARK: - ProfileEndpoint

    enum Profile {

        struct Update: Encodable {
            var firstName: String?
            var lastName: String?
            var avatarID: String?
            var email: String?

            enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case lastName = "last_name"
                case avatarID = "avatar_id"
                case email
            }
        }

    }



}




