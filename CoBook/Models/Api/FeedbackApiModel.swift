//
//  FeedbackApiModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 18.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct FeedbackItemApiModel: Decodable {
    
    // MARK: Root object
    var id: Int?
    var body: String?
    var creator: Creator?
    
    enum CodingKeys: String, CodingKey {
        case id
        case body
        case creator = "created_by"
    }
    
    // MARK: Creator object
    struct Creator: Decodable {
        var id: String?
        var firstName: String?
        var lastName: String?
        var avatar: FileDataApiModel?
        
        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar
        }
    }
}
