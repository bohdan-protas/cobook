//
//  PersonalCardAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCardAPI {

    // MARK: - Response
    enum Response {

        struct Interest: Decodable {
            var id: Int
            var title: String?
        }

        struct Practice: Decodable {
            var id: Int
            var title: String?
        }

        struct Creation: Decodable {
            var id: Int
        }

    }

    // MARK: - Request

    enum Request {

        struct CreationParameters: Encodable {

            enum CodingKeys: String, CodingKey {
                case avatarId = "avatar_id"
                case cityPlaceId = "city_place_id"
                case regionPlaceId = "region_place_id"
                case position
                case description
                case practiseTypeId = "practise_type_id"
                case interestsIds = "interests_ids"
                case contactTelephone = "contact_telephone"
                case contactEmail = "contact_email"
                case socialNetworks = "social_networks"
            }

            var avatarId: String?
            var cityPlaceId: String?
            var regionPlaceId: String?
            var position: String?
            var description: String?
            var practiseTypeId: Int?
            var interestsIds: [Int]?
            var contactTelephone: String?
            var contactEmail: String?
            var socialNetworks: [SocialNetwork] = []

            var isRequiredDataIsFilled: Bool {
                return
                    !(avatarId ?? "").isEmpty &&
                    !(cityPlaceId ?? "").isEmpty &&
                    !(regionPlaceId ?? "").isEmpty &&
                    !(position ?? "").isEmpty &&
                    !(description ?? "").isEmpty &&
                    !(practiseTypeId == nil) &&
                    !(interestsIds ?? []).isEmpty &&
                    !(contactTelephone ?? "").isEmpty &&
                    !(contactEmail ?? "").isEmpty
            }
        }

        struct SocialNetwork: Encodable {
            var title: String
            var link: String
        }


    }




}
