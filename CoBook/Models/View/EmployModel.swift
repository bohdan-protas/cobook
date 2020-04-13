//
//  EmployModel.swift
//  CoBook
//
//  Created by protas on 4/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct EmployeeModel {
    var userId: String?
    var cardId: Int?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    var position: String?
    var telephone: String?
    var practiceType: PracticeModel?

    var nameAbbreviation: String? {
        return (firstName?.first?.uppercased() ?? "") + " " + (lastName?.first?.uppercased() ?? "")
    }

    static func == (lhs: EmployeeModel, rhs: EmployeeModel) -> Bool {
        if let lhsId = lhs.userId, let rhsId = rhs.userId {
            return lhsId == rhsId
        } else {
            return false
        }
    }
}
