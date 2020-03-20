//
//  SocialListItem.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Social {

    enum LinkType: CaseIterable {
        case telegram
        case linkedin
        case viber
        case facebookMessanger

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
            }
        }

        var associatedHost: [String] {
            switch self {
            case .telegram:
                return ["t.me", "telegram.org"]
            case .linkedin:
                return ["www.linkedin.com"]
            case .viber:
                return ["www.viber.com"]
            case .facebookMessanger:
                return ["www.facebook.com"]
            }
        }
    }

    static func detectFrom(url: URL?) -> Social.LinkType? {
        var detectedType: Social.LinkType?

        guard let url = url, let detectingLinkHost = url.host else {
            Log.debug("Cannot fetch host")
            return detectedType
        }

        Social.LinkType.allCases.forEach { linkType in
            if linkType.associatedHost.contains(detectingLinkHost) {
                Log.debug("Detected link host \(detectingLinkHost): \(linkType)")
                detectedType = linkType
            } else {
                Log.debug("\(linkType) type not associated with host \(detectingLinkHost)")
            }
        }

        return detectedType
    }

    enum ListItem {
        case view(model: Model)
        case add
    }

    struct Model {
        let title: String
        let url: URL?
        let type: LinkType?

        init(title: String, url: URL?) {
            self.title = title
            self.url = url
            self.type = detectFrom(url: url)
        }

    }
    

}
