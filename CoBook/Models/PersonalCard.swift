//
//  PersonalCard.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCard {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case title(text: String)
        case textField(type: TextType, action: ActionType?)
        case textView(type: TextType)
    }

    enum TextType: String {
        case occupiedPosition               // Займана посада
        case activityType                   // Вид діяльності
        case placeOfLiving                  // Місце проживання
        case activityRegion                 // Регіон діяльності
        case activityDescription            // Опис діяльності
        case workingPhoneNumber             // Робочий номер телефону
        case workingEmailForCommunication   // Робочий емейл для зв'язку

        var placeholder: String {
            get {
                switch self {
                case .occupiedPosition:
                    return "Займана посада"
                case .activityType:
                    return "Вид діяльності"
                case .placeOfLiving:
                    return "Місце проживання"
                case .activityRegion:
                    return "Регіон діяльності"
                case .activityDescription:
                    return "Опис діяльності"
                case .workingPhoneNumber:
                    return "Робочий номер телефону"
                case .workingEmailForCommunication:
                    return "Робочий емейл для зв'язку"
                }
            }
        }

    }

    enum ActionType: String {
        case listOfActivities
        case placeAutocomplete
    }


}
