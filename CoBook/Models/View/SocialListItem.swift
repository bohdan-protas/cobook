//
//  SocialListItem.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Social {

    enum LinkType {
        case telegram
        case linkedin
        case viber
        case facebookMessanger
        case other

        var image: UIImage {
            switch self {
            case .telegram:
                return #imageLiteral(resourceName: "ic_social_telegram")
            case .linkedin:
                return #imageLiteral(resourceName: "ic_social_linkedin")
            case .viber:
                return #imageLiteral(resourceName: "ic_social_viber")
            case .facebookMessanger:
                return #imageLiteral(resourceName: "of_social_facebook-messanger")
            case .other:
                return #imageLiteral(resourceName: "ic_social_default")
            }
        }
    }

    enum ListItem {
        case view(model: Model)
        case add
    }

    struct Model {
        let title: String
        let url: URL?
        let type: LinkType

    }
    

}
