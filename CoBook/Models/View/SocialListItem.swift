//
//  SocialListItem.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Social {

    enum ListItem {
        case view(model: Model)
        case add
    }

    struct Model {
        let title: String?
        let url: URL?

        init(title: String?, url: URL?) {
            self.title = title
            self.url = url
        }

        init(title: String?, url: String?) {
            self.title = title
            self.url = URL.init(string: url ?? "")
        }

    }
    

}
