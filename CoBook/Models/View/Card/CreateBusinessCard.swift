//
//  CreateBusinessCard.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CreateBusinessCard {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case avatarPhotoManagment(sourceType: CardAvatarPhotoManagmentTableViewCell.SourceType, imagePath: String?)
        case sectionHeader
        case title(text: String)
        case textField(text: String?, type: TextType)
        case actionTextField(text: String?, type: ActionType)
        case interests(list: [Card.InterestItem])
        case socialList(list: [Social.ListItem])

    }

    enum TextType: String {
        case companyName
        case companyWebSite
        case workingPhoneNumber

        var placeholder: String {
            get {
                switch self {
                case .companyName:
                    return "Назва компанії"
                case .companyWebSite:
                    return "Веб-сайт компанії"
                case .workingPhoneNumber:
                    return "Робочий номер телефону"
                }
            }
        }

        var keyboardType: UIKeyboardType {
            get {
                switch self {
                case .companyName:
                    return .default
                case .companyWebSite:
                    return .URL
                case .workingPhoneNumber:
                    return .phonePad
                }
            }
        }

    }

    enum ActionType: RawRepresentable {
        case activityType(list: [Card.PracticeItem])
        case city
        case region
        case address
        case schedule

        var placeholder: String {
            get {
                switch self {
                case .activityType:
                    return "Вид діяльності"
                case .city:
                    return "Місто розташування"
                case .region:
                    return "Місто діяльності"
                case .address:
                    return "Вулиця"
                case .schedule:
                    return "Графік роботи (дні та години)"
                }
            }
        }

        public typealias RawValue = String

        /// Failable Initalizer
        public init?(rawValue: RawValue) {
            switch rawValue {
            case "activityType":    self = .activityType(list: [])
            case "city":            self = .city
            case "region":          self = .region
            case "address":         self = .address
            case "schedule":        self = .schedule
            default:
                return nil
            }
        }

        /// Backing raw value
        public var rawValue: RawValue {
            switch self {
            case .activityType:     return "activityType"
            case .city:             return "city"
            case .region:           return "region"
            case .address:          return "address"
            case .schedule:         return "schedule"
            }
        }
    }


}
