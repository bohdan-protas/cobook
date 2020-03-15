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
                                              completion: @escaping (AFResult<APIResponse<T>>) -> Void) -> DataRequest {

        return session.request(router)
            .responseDecodable(of: APIResponse<T>.self, queue: .main, decoder: decoder) { (response) in
                debugPrint(response.error.debugDescription)
                completion(response.result)
            }
    }


}

// MARK: - Sign Up requests
extension APIClient {

    /**
     Initialize registration session

     - parameters:
        - email:  users email number
        - telephone:  usesr telephone number
        - firstName:  users firstName
        - lastName:  parsed response from server
     */
    func signUpInitializationRequest(email: String,
                                     telephone: String,
                                     firstName: String,
                                     lastName: String,
                                     completion: @escaping (AFResult<APIResponse<SignInAPIResponseData>>) -> Void) {

        let router = SignUpRouter.initialize(email: email, telephone: telephone, firstName: firstName, lastName: lastName)
        performRequest(router: router, completion: completion)
    }

    /**
     Verify telephone via sms

     - parameters:
        - smsCode: 4 digit sms code
        - accessToken: users access token
        - completion: parsed response from server
     */
    func verifyRequest(smsCode: Int,
                       accessToken: String,
                       completion: @escaping (AFResult<APIResponse<VerifyAPIResponseData>>) -> Void) {

        let router = SignUpRouter.verify(smsCode: smsCode, accessToken: accessToken)
        performRequest(router: router, completion: completion)
    }

    /**
     Request resend sms

     - parameters:
        - accessToken: users access token
        - completion: parsed response from server
     */
    func resendSmsRequest(accessToken: String,
                          completion: @escaping (AFResult<APIResponse<SignInAPIResponseData>>) -> Void) {

        let router = SignUpRouter.resend(accessToken: accessToken)
        performRequest(router: router, completion: completion)
    }

    /**
     Finish initialization registration session request

     - parameters:
        - login:  user telephone number
        - password:  user account password
        - completion: parsed response from server
     */
    func signUpFinishRequest(accessToken: String,
                             password: String,
                             completion: @escaping (AFResult<APIResponse<RegisterAPIResponseData>>) -> Void) {

        let router = SignUpRouter.finish(accessToken: accessToken, password: password)
        performRequest(router: router, completion: completion)
    }


}

// MARK: - Sign In requests
extension APIClient {
    /**
     Login request.

     - parameters:
        - login:  user telephone number
        - password:  user account password
        - completion: parsed response from server
     */
    func signInRequest(login: String,
                       password: String,
                       completion: @escaping (AFResult<APIResponse<RegisterAPIResponseData>>) -> Void) {

        let router = SignInRouter.login(login: login, password: password)
        performRequest(router: router, completion: completion)
    }
}

// MARK: - Auth requests
extension APIClient {

    /**
     Request access token via refresh token

     - parameters:
        - refreshToken: current users refresh token
        - completion: parsed response from server
     */
    func refreshTokenRequest(refreshToken: String,
                             completion: @escaping (AFResult<APIResponse<RefreshTokenAPIResponseData>>) -> Void) {

        let router = AuthRouter.refresh(refreshToken: refreshToken)
        performRequest(router: router, completion: completion)
    }

    /**
     Request new credentials via login

     - parameters:
        - telephone: current users telephone number
        - completion: parsed response from server
     */
    func forgotPasswordRequest(telephone: String,
                               completion: @escaping (AFResult<APIResponse<VoidResponseData>>) -> Void) {

        let router = AuthRouter.forgotPassword(telephone: telephone)
        performRequest(router: router, completion: completion)
    }

}

// MARK: -
extension APIClient {

    /**
     Request localized list of interests
    */
    func interestsListRequest(completion: @escaping (AFResult<APIResponse<[PersonalCardAPIResponseData.Interest]>>) -> Void) {
        let router = InterestsRouter.list
        performRequest(router: router, completion: completion)
    }


}
