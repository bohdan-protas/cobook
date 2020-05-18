//
//  Notifications + Extensions.swift
//  CoBook
//
//  Created by protas on 5/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let cardSaved: Notification.Name = Notification.Name("saveCardNotificationName")
    static let cardUnsaved: Notification.Name = Notification.Name("unsaveCardNotificationName")

    static let articleSaved: Notification.Name = Notification.Name("saveArticleNotificationName")
    static let articleUnsaved: Notification.Name = Notification.Name("unsaveArticleNotificationName")
}

extension Notification {

    enum Key {
        static let controllerID: String = "controllerID"
        static let cardID: String = "cardID"
        static let articleID: String = "articleID"
    }

}
