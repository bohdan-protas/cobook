//
//  NavigableView.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol NavigableView {
    func push(controller: UIViewController, animated: Bool)
    func present(controller: UIViewController, animated: Bool)
    func popController()
}

protocol MessagingCallingView {
    func sendEmail(to emailAddress: String)
    func makeCall(to telephoneNumber: String?)
}
