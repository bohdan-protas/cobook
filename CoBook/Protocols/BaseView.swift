//
//  BaseView.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

public protocol BaseView: class {
    func startLoading()
    func finishLoading()
}

extension BaseView {
    func startLoading() { }
    func finishLoading() { }
}
