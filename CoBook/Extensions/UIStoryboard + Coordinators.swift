//
//  UIStoryboard + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static var auth: UIStoryboard {
        return UIStoryboard(name: "Auth", bundle: nil)
    }

    static var account: UIStoryboard {
        return UIStoryboard(name: "Account", bundle: nil)
    }

    static var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }

    static var allCards: UIStoryboard {
        return UIStoryboard(name: "AllCards", bundle: nil)
    }

    static var post: UIStoryboard {
        return UIStoryboard(name: "Post", bundle: nil)
    }

    static var saved: UIStoryboard {
        return UIStoryboard(name: "Saved", bundle: nil)
    }


}
