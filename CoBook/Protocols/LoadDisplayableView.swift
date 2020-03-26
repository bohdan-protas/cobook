//
//  BaseView.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

public protocol LoadDisplayableView: class {
    func startLoading()
    func stopLoading()


    func startLoading(text: String?)
    func stopLoading(success: Bool)
    func stopLoading(success: Bool, completion: (() -> Void)?)
}




