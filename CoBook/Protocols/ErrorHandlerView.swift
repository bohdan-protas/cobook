//
//  ErrorHandlerView.swift
//  CoBook
//
//  Created by protas on 3/18/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

protocol ErrorHandlerView {
    func handle(error: AFError?)
}
