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
        case textField(type: TextType)
        case textFieldAction(type: ActionType)
    }

    enum TextType {
        case occupiedPosition               // Займана посада
        case activityRegion                 // Регіон діяльності
        case activityDescription            // Опис діяльності
        case workingPhoneNumber             // Робочий номер телефону
        case workingEmailForCommunication   // Робочий емейл для зв'язку
    }

    enum ActionType {
        case activity                       // Вид діяльності
        case placeOfLiving                  // Місце проживання
    }


}
