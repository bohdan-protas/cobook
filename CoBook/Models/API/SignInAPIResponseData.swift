//
//  SignInAPIResponse.swift
//  CoBook
//
//  Created by protas on 2/24/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct SignInAPIResponseData {
    /// UUID represented session identifier
    var accessToken: String?

    /// time in ms left to resend message
    var smsResendLeftInMs: TimeInterval?
}

extension SignInAPIResponseData: Decodable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "s_id"
        case smsResendLeftInMs = "sms_resend_left"
    }
}


