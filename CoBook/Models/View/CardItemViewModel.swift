//
//  CardItemViewModel.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardItemViewModel {
    var id: String?
    var type: CardType
    var avatarPath: String?
    var firstName: String?
    var lastName: String?
    var profession: String?
    var telephoneNumber: String?

    var nameAbbreviation: String? {
        return (firstName?.first?.uppercased() ?? "") + " " + (lastName?.first?.uppercased() ?? "")
    }
}
