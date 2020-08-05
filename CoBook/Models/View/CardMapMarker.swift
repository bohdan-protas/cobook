//
//  CardMapMarker.swift
//  CoBook
//
//  Created by Bogdan Protas on 05.08.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import GoogleMaps

struct CardMapMarker {
    var cardID: Int
    var cardType: CardType
    var marker: GMSMarker?
}
