//
//  CreateBusinessCard.swift
//  CoBook
//
//  Created by protas on 4/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CreateBusinessCard {

    enum Cell {
        case backgroundImageManagment(model: BackgroundManagmentImageCellModel)
        case avatarManagment(model: CardAvatarManagmentCellModel)
        case title(text: String)
        case sectionHeader
        case textField(model: TextFieldModel)
        case actionField(model: ActionFieldModel)
        case textView(model: TextFieldModel)
        case socials
        case interests
        case employersSearch
        case employersList
    }

    enum ActionType: String {
        case practice
        case city
        case region
        case address
    }

    struct DetailsModel {
        var cardId: Int?

        var avatarImage: FileDataApiModel?
        var avatarImageData: Data?

        var backgroudImage: FileDataApiModel?
        var backgroudImageData: Data?

        var companyName: String?
        var practiseType: PracticeModel?
        var contactTelephone: String?
        var companyWebSite: String?
        var companyEmail: String?

        var city: PlaceModel?
        var region: PlaceModel?
        var address: PlaceModel?
        var schedule: String?

        var description: String?

        var employers = [EmployeeModel]()
        var interests: [TagModel] = []
        var socials: [Social.ListItem] = []
        var practices: [PracticeModel] = []

        init() {}

        init(apiModel: CardDetailsApiModel) {
            self.cardId = apiModel.id

            self.avatarImage = apiModel.avatar
            self.backgroudImage = apiModel.background

            self.companyName = apiModel.company?.name
            self.practiseType = PracticeModel(id: apiModel.practiceType?.id, title: apiModel.practiceType?.title)
            self.contactTelephone = apiModel.contactTelephone?.number
            self.companyWebSite = apiModel.companyWebSite
            self.companyEmail = apiModel.contactEmail?.address

            self.city = PlaceModel(googlePlaceId: apiModel.city?.googlePlaceId, name: apiModel.city?.name)
            self.region = PlaceModel(googlePlaceId: apiModel.region?.googlePlaceId, name: apiModel.region?.name)
            self.address = PlaceModel(googlePlaceId: apiModel.address?.googlePlaceId, name: apiModel.address?.name)
            self.schedule = apiModel.schedule

            self.description = apiModel.description


            self.interests = apiModel.interests?.compactMap { TagModel(id: $0.id, title: $0.title, isSelected: true) } ?? []
            self.socials = apiModel.socialNetworks?.compactMap { Social.ListItem.view(model: .init(title: $0.title, url: $0.link)) } ?? []
        }


    }

}


