//
//  OnboardingModel.swift
//  CoBook
//
//  Created by protas on 2/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Onboarding {

    enum ButtonActionType {
        case next
        case finish
    }

    struct PageModel {
        var title: String?
        var subtitle: String?
        var image: UIImage?
        var actionTitle: String
        var action: ButtonActionType
    }


}

