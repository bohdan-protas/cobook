//
//  CardMapPinApiModel.swift
//  CoBook
//
//  Created by protas on 4/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardMapMarkerApiModel {
    var id: Int
    var type: CardType
    var latitide: Double?
    var longiture: Double?
    var placeId: String?
    var name: String?
}

extension CardMapMarkerApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case latitide = "lat"
        case longiture = "lng"
        case placeId = "place_id"
        case name
    }

}
