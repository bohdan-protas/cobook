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

    // MARK: - SignUp

    enum SignUp {

        struct Initialize: Encodable {
            var email: String
            var telephone: String
            var firstName: String
            var lastName: String
            var invitedBy: String?

            enum CodingKeys: String, CodingKey {
                case email
                case telephone = "telephone"
                case firstName = "first_name"
                case lastName = "last_name"
                case invitedBy = "invited_by"
            }
        }

    }

    // MARK: - Auth

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

    // MARK: -  Card

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
    
    // MARK: - Feedback
    
    enum Feedback {
        
        struct Create: Encodable {
            var id: Int?
            var body: String?
            
            enum CodingKeys: String, CodingKey {
                case id = "card_id"
                case body
            }
        }
        
        struct List: Encodable {
            var id: Int?
            var limit: Int?
            var offset: Int?
            
            enum CodingKeys: String, CodingKey {
                case id = "card_id"
                case limit
                case offset
            }
        }
        
    }
    
    // MARK: - Bonuses
    
    enum Bonuses {
        
        struct LeaderbordStats: Encodable {
            var inMyRegion: Bool
            var limit: Int?
            var offset: Int?
            
            enum CodingKeys: String, CodingKey {
                case inMyRegion = "in_my_region"
                case limit
                case offset
            }
        }
    }

    
}




