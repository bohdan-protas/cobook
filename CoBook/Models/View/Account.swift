//
//  Model.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Account {

    enum Item {
        case title(text: String)
        case sectionHeader
        case userInfoHeader(model: UserInfoHeaderModel?)
        case menuItem(model: AccountMenuItemModel)
        case personalCardPreview(model: CardPreviewModel)
        case businessCardPreview(model: CardPreviewModel)
    }

    struct AccountMenuItemModel {
        var title: String
        var image: UIImage?
        var actiontype: ActionType
    }

    struct UserInfoHeaderModel {
        var avatarUrl: String?
        var firstName: String?
        var lastName: String?
        var telephone: String?
        var email: String?
    }

    enum ActionType {
        case createPersonalCard
        case createBusinessCard
        
        case inviteFriends
        case staticticsOfCards
        case generateQrCode
        case faq
        case startMakingMoney
        
        case study
        case referalLink
        case financies
        case staticticsOfPartnership
        
        case quitAccount
    }


}
