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
    var smsResendLeft: Int?
}

extension SignInAPIResponseData: Decodable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "s_id"
        case smsResendLeft = "sms_resend_left"
    }


}
