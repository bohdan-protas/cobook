//
//  PersonalCard.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CreatePersonalCard {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case title(text: String)
        case textField(text: String?, type: TextType)
        case actionTextField(text: String?, type: ActionType)
        case textView(text: String?, type: TextType)
        case interests(list: [Interest])
        case socialList(list: [Social.ListItem])
    }

    enum TextType: String {
        case occupiedPosition               // Займана посада
        case activityDescription            // Опис діяльності
        case workingPhoneNumber             // Робочий номер телефону
        case workingEmailForCommunication   // Робочий емейл для зв'язку

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
                }
            }
        }

        var contentType: UITextContentType? {
            switch self {
            case .occupiedPosition:
                return .jobTitle
            case .activityDescription:
                return nil
            case .workingPhoneNumber:
                return .telephoneNumber
            case .workingEmailForCommunication:
                return .emailAddress

            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .occupiedPosition:
                return .default
            case .activityDescription:
                return .default
            case .workingPhoneNumber:
                return .phonePad
            case .workingEmailForCommunication:
                return .emailAddress
            }
        }

    }

    enum ActionType: RawRepresentable {
        case activityType(list: [Practice])     // Вид діяльності
        case placeOfLiving                      // Місце проживання
        case activityRegion                     // Регіон діяльності

        var placeholder: String {
            switch self {
            case .activityType:
                return "Вид діяльності"
            case .placeOfLiving:
                return "Місце проживання"
            case .activityRegion:
                return "Регіон діяльності"
            }
        }

        public typealias RawValue = String

        /// Failable Initalizer
        public init?(rawValue: RawValue) {
            switch rawValue {
            case "activityType":    self = .activityType(list: [])
            case "placeOfLiving":   self = .placeOfLiving
            case "activityRegion":  self = .activityRegion
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
            }
        }
    }

    struct Interest {
        var id: Int?
        var title: String?
        var isSelected: Bool = false
    }

    struct Practice {
        var id: Int?
        var title: String?
        var isSelected: Bool = false
    }


}
