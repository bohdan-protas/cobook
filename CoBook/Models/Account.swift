//
//  Model.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Account {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case action(type: ActionType)
        case businessCard(model: BusinessCard)
    }

    struct BusinessCard {
        var image: String
        var name: String
        var profession: String
        var telephone: String
    }

    enum ActionType {
        case createPersonalCard
        case createBusinessCard
        case inviteFriends
        case statictics
        case generateQrCode
        case faq
        case startMakingMoney
        case quitAccount

        var image: UIImage? {
            get {
                switch self {
                case .createPersonalCard:
                    return #imageLiteral(resourceName: "ic_account_createparsonalcard")
                case .createBusinessCard:
                    return #imageLiteral(resourceName: "ic_account_createbusinescard")
                case .inviteFriends:
                    return #imageLiteral(resourceName: "ic_account_invitefriends")
                case .statictics:
                    return #imageLiteral(resourceName: "ic_account_statistics")
                case .generateQrCode:
                    return #imageLiteral(resourceName: "ic_account_qrcode")
                case .faq:
                    return #imageLiteral(resourceName: "ic_account_faq")
                case .startMakingMoney:
                    return #imageLiteral(resourceName: "ic_account_startmakingmoney")
                case .quitAccount:
                    return #imageLiteral(resourceName: "ic_account_logout")
                }
            }
        }

        var title: String {
            get {
                switch self {
                case .createPersonalCard:
                    return "Account.item.createPersonalCard".localized//Create personal business card"
                case .createBusinessCard:
                    return "Account.item.createBusinessCard".localized//Create personalCard"
                case .inviteFriends:
                    return "Account.item.inviteFriends".localized//Invite friends"
                case .statictics:
                    return "Account.item.statictics".localized//Statistics"
                case .generateQrCode:
                    return "Account.item.generateQrCode".localized
                case .faq:
                    return "Account.item.faq".localized
                case .startMakingMoney:
                    return "Account.item.startMakingMoney".localized
                case .quitAccount:
                    return "Account.item.quitAccount".localized
                }
            }
        }
    }


}
