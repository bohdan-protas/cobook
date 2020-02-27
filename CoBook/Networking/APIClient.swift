//
//  APIClient.swift
//  CoBook
//
//  Created by protas on 2/24/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {

    // MARK: Properties
    /// Singleton
    public static var `default`: APIClient = {
        let evaluators = [APIConstants.baseURLPath.host ?? "": DisabledEvaluator()]
        let manager = ServerTrustManager(evaluators: evaluators)
        let session = Session(serverTrustManager: manager)

        let apiClient = APIClient(session: session)
        return apiClient
    }()

    private var session: Session

    // MARK: Initializer
    private init(session: Session) {
        self.session = session
    }

    // MARK: Public
    @discardableResult
    private func performRequest<T: Decodable>(router: APIConfigurable,
                                                    decoder: JSONDecoder = JSONDecoder(),
                                                    completion: @escaping (AFResult<APIResponse<T>>) -> Void) -> DataRequest{


        return session.request(router).responseDecodable(of: APIResponse<T>.self, queue: .main, decoder: decoder) { (response) in
            completion(response.result)
        }
    }


}

// MARK: - Sign Up
extension APIClient {

    /// Initialize registration session
    func signUpInitializationRequest(email: String,
                                     telephone: String,
                                     firstName: String,
                                     lastName: String,
                                     completion: @escaping (AFResult<APIResponse<SignInAPIResponseData>>) -> Void) {

        let router = SignUpRouter.initialize(email: email, telephone: telephone, firstName: firstName, lastName: lastName)
        performRequest(router: router, completion: completion)
    }

    /// Verify telephone via sms
    func verifyRequest(smsCode: Int,
                       accessToken: String,
                       completion: @escaping (AFResult<APIResponse<VerifyAPIResponseData>>) -> Void) {

        let router = SignUpRouter.verify(smsCode: smsCode, accessToken: accessToken)
        performRequest(router: router, completion: completion)
    }

    func resendSmsRequest(accessToken: String,
                          completion: @escaping (AFResult<APIResponse<SignInAPIResponseData>>) -> Void) {

        let router = SignUpRouter.resend(accessToken: accessToken)
        performRequest(router: router, completion: completion)
    }

    func signUpFinishRequest(accessToken: String,
                             password: String,
                             completion: @escaping (AFResult<APIResponse<FinishRegistratrationAPIResponseData>>) -> Void) {
        let router = SignUpRouter.finish(accessToken: accessToken, password: password)
        performRequest(router: router, completion: completion)
    }


}
