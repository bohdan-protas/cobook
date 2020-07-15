//
//  WorkplaceAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 15.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct WorkplaceAPIModel: Decodable {
    var id: Int?
    var company: CompanyApiModel?
}
