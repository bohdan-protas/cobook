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
        var avatarImageData: Data?

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

        init() {}

        init(apiModel: CardDetailsApiModel) {
            self.avatarImage = apiModel.avatar

            self.position = apiModel.position
            self.practiseType = PracticeModel(id: apiModel.practiceType?.id, title: apiModel.practiceType?.title)
            self.city = PlaceModel(googlePlaceId: apiModel.city?.googlePlaceId, name: apiModel.city?.name)
            self.region = PlaceModel(googlePlaceId: apiModel.region?.googlePlaceId, name: apiModel.region?.name)
            self.description = apiModel.description
            self.contactTelephone = apiModel.contactTelephone?.number
            self.contactEmail = apiModel.contactEmail?.address
            self.interests = apiModel.interests?.compactMap { InterestModel(id: $0.id, title: $0.title, isSelected: true) } ?? []
            self.socials = apiModel.socialNetworks?.compactMap { Social.ListItem.view(model: .init(title: $0.title, url: $0.link)) } ?? []

        }
    }

}


