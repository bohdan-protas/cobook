//
//  BaseView.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

public protocol LoadDisplayableView {
    func startLoading()
    func stopLoading()

    func showTextHud(_ text: String?)
    func startLoading(text: String?)
    func stopLoading(success: Bool)
    func stopLoading(success: Bool, completion: (() -> Void)?)
    func stopLoading(success: Bool, succesText: String?, failureText: String?, completion: (() -> Void)?)
}




