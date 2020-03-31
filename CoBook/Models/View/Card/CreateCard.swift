//
//  Card.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CreateCard {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case avatarPhotoManagment(sourceType: CardAvatarPhotoManagmentTableViewCell.SourceType, imagePath: String?)
        case title(text: String)
        case textField(text: String?, type: TextType)
        case actionTextField(text: String?, type: ActionType)
        case textView(text: String?, type: TextType)
        case interests(list: [InterestItem])
        case socialList(list: [Social.ListItem])
        case sectionHeader
    }

    enum TextType: String {
        case occupiedPosition
        case activityDescription
        case workingPhoneNumber
        case workingEmailForCommunication
        case companyName
        case companyWebSite
        case schedule

        var placeholder: String {
            get {
                switch self {
                case .occupiedPosition:
                    return "Займана посада"
                case .activityDescription:
                    return "Опис діяльності"
                case .workingPhoneNumber:
                    return "Робочий номер телефону"
                case .workingEmailForCommunication:
                    return "Робочий емейл для зв'язку"
                case .companyName:
                    return "Назва компанії"
                case .companyWebSite:
                    return "Веб-сайт компанії"
                case .schedule:
                    return "Графік роботи (дні та години)"
                }
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .occupiedPosition, .companyName, .activityDescription, .schedule:
                return .default
            case .workingPhoneNumber:
                return .phonePad
            case .workingEmailForCommunication:
                return .emailAddress
            case .companyWebSite:
                return .URL
            }
        }
    }

    enum ActionType: RawRepresentable {
        case activityType(list: [PracticeItem])
        case placeOfLiving
        case activityRegion
        case city
        case region
        case address


        var placeholder: String {
            switch self {
            case .activityType:
                return "Вид діяльності"
            case .placeOfLiving:
                return "Місце проживання"
            case .activityRegion:
                return "Регіон діяльності"
            case .city:
                return "Місто розташування"
            case .region:
                return "Місто діяльності"
            case .address:
                return "Вулиця"

            }
        }

        public typealias RawValue = String

        /// Failable Initalizer
        public init?(rawValue: RawValue) {
            switch rawValue {
            case "activityType":    self = .activityType(list: [])
            case "placeOfLiving":   self = .placeOfLiving
            case "activityRegion":  self = .activityRegion
            case "city":            self = .city
            case "region":          self = .region
            case "address":         self = .address
            default:
                return nil
            }
        }

        /// Backing raw value
        public var rawValue: RawValue {
            switch self {
            case .activityType:     return "activityType"
            case .placeOfLiving:    return "placeOfLiving"
            case .activityRegion:   return "activityRegion"
            case .city:             return "city"
            case .region:           return "region"
            case .address:          return "address"
            }
        }
    }

    struct PracticeItem {
        var id: Int?
        var title: String?
        var isSelected: Bool = false
    }

    struct InterestItem {
        var id: Int?
        var title: String?
        var isSelected: Bool = false
    }

}
