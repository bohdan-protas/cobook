//
//  SignInAPIResponse.swift
//  CoBook
//
//  Created by protas on 2/24/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct SignInAPIResponseData {
    var accessToken: String?
    var smsResendLeftInMiliseconds: TimeInterval?
}

extension SignInAPIResponseData: Decodable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "s_id"
        case smsResendLeftInMiliseconds = "sms_resend_left"
    }
}


