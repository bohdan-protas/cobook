//
//  Card.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CreatePersonalCard {

    enum Cell {
        case avatarManagment(model: CardAvatarManagmentCellModel)
        case title(text: String)
        case sectionHeader
        case textField(model: TextFieldModel)
        case actionField(model: ActionFieldModel)
        case textView(model: TextFieldModel)
        case socials
        case interests
    }

    enum ActionType: String {
        case activityType
        case placeOfLiving
        case activityRegion
    }

    struct DetailsModel {
        var avatarImage: FileDataApiModel?

        var position: String?
        var practiseType: PracticeModel?
        var city: PlaceModel?
        var region: PlaceModel?
        var description: String?

        var contactTelephone: String?
        var contactEmail: String?

        var interests: [InterestModel] = []
        var socials: [Social.ListItem] = []
        var practices: [PracticeModel] = []
    }

    
}


