//
//  PersonalCardAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCardAPIResponseData {

    struct Interest: Decodable {
        var id: Int
        var title: String?
    }


}
