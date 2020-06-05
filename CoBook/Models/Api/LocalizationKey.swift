//
//  LocalizationKey.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum APILanguageCode: String {
    case uk = "UKR"
    case en = "ENG"
    case ru = "RUS"

    init(deviceLanguageCode: String?) {
        switch deviceLanguageCode {
        case "uk":
            self = .uk
        case "en":
            self = .en
        case "ru":
            self = .ru
        default:
            self = .en
        }
    }
}
