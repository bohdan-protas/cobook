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
        case facebookMessanger

        var image: UIImage {
            switch self {
            case .telegram:
                return #imageLiteral(resourceName: "ic_social_telegram")
            case .linkedin:
                return #imageLiteral(resourceName: "ic_social_linkedin")
            case .facebookMessanger:
                return #imageLiteral(resourceName: "ic_social_facebook")
            }
        }

        var associatedHost: [String] {
            switch self {
            case .telegram:
                return ["t.me", "telegram.org"]
            case .linkedin:
                return ["www.linkedin.com", "linkedin.com"]
            case .facebookMessanger:
                return ["www.facebook.com", "m.facebook.com", "facebook.com"]
            }
        }

    }

    static func detectFrom(url: URL?) -> Social.LinkType? {
        var detectedType: Social.LinkType?
        guard let url = url else {
            return detectedType
        }

        if let detectingLinkHost = url.host {
            Social.LinkType.allCases.forEach { linkType in
                if linkType.associatedHost.contains(detectingLinkHost) {
                    detectedType = linkType
                }
            }
        }

        return detectedType
    }

    enum ListItem {
        case view(model: Model)
        case add
    }

    struct Model {
        let title: String?
        let url: URL?
        let type: LinkType?

        init(title: String?, url: URL?) {
            self.title = title
            self.url = url
            self.type = detectFrom(url: url)
        }

        init(title: String?, url: String?) {
            self.title = title
            self.url = URL.init(string: url ?? "")
            self.type = detectFrom(url: self.url)
        }

    }
    

}
