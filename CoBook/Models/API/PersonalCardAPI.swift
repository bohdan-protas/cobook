//
//  PersonalCardAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCardAPI {

    // MARK: - Response
    enum Response {

        struct Interest: Decodable {
            var id: Int
            var title: String?
        }

        struct Practice: Decodable {
            var id: Int
            var title: String?
        }

    }

    // MARK: - Request
    enum Request {

    }


}
