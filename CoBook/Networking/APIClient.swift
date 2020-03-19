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

        let loggerMonitor = LoggerEventMonitor()
        let requestInterceptor = AuthRequestInterceptor()
        let session = Session(interceptor: requestInterceptor, serverTrustManager: manager, eventMonitors: [loggerMonitor])

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
    private func performRequest<T: Decodable>(router: Router,
                                              decoder: JSONDecoder = JSONDecoder(),
                                              completion: @escaping (Result<APIResponse<T>, Error>) -> Void) -> DataRequest {

        return session.request(router)
            .validate()
            .response { (response) in
                if let responseData = response.data {
                    do {
                        let decodedResponse = try decoder.decode(APIResponse<T>.self, from: responseData)
                        switch decodedResponse.status {
                        case .ok:
                            completion(.success(decodedResponse))
                        case .error:
                            let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: decodedResponse.errorLocalizadMessage ?? "Undefined error occured")
                            completion(.failure(error))
                        }
                    } catch {
                        let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Received data in bad format")
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Something bad happens, try anain later.")
                    completion(.failure(error))
                }
            }
    } // end performRequest

    @discardableResult
    private func upload<T: Decodable>(imageData: Data,
                                      to endpoint: URLConvertible,
                                      headers: HTTPHeaders?,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: @escaping (AFResult<APIResponse<T>>) -> Void) -> DataRequest {

        return session.upload(multipartFormData: { multipartFormData in
            let randomName = "\(String.random())-image"
            multipartFormData.append(imageData, withName: randomName, fileName: "\(randomName).png", mimeType: "image/png")
        }, to: endpoint, headers: headers)
            .uploadProgress { progress in
                Log.debug("Photo upload Progress: \(progress.fractionCompleted)")
            }
            .responseDecodable(of: APIResponse<T>.self, decoder: decoder) { (response) in
                completion(response.result)
        }
    } // end upload


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
                                     completion: @escaping (Result<APIResponse<SignInAPIResponseData>, Error>) -> Void) {

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
                       completion: @escaping (Result<APIResponse<VerifyAPIResponseData>, Error>) -> Void) {

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
                          completion: @escaping (Result<APIResponse<SignInAPIResponseData>, Error>) -> Void) {

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
                             completion: @escaping (Result<APIResponse<RegisterAPIResponseData>, Error>) -> Void) {

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
                       completion: @escaping (Result<APIResponse<RegisterAPIResponseData>, Error>) -> Void) {

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
                             completion: @escaping (Result<APIResponse<RefreshTokenAPIResponseData>, Error>) -> Void) {

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
                               completion: @escaping (Result<APIResponse<VoidResponseData>, Error>) -> Void) {

        let router = AuthRouter.forgotPassword(telephone: telephone)
        performRequest(router: router, completion: completion)
    }

}

// MARK: - Interests router requests
extension APIClient {

    /**
     Request localized list of interests
    */
    func interestsListRequest(completion: @escaping (Result<APIResponse<[PersonalCardAPI.Response.Interest]>, Error>) -> Void) {
        let router = InterestsRouter.list
        performRequest(router: router, completion: completion)
    }


}

// MARK: - PracticeTypesRouter request
extension APIClient {

    /**
     Request localized list of practice types
    */
    @discardableResult
    func practicesTypesListRequest(completion: @escaping (Result<APIResponse<[PersonalCardAPI.Response.Practice]>, Error>) -> Void) -> DataRequest{
        let router = PracticeTypesRouter.list
        return performRequest(router: router, completion: completion)
    }


}

// MARK: - CardsRouter requests
extension APIClient {

    /**
     Request create personal card
    */
    @discardableResult
    func createPersonalCard(parameters: PersonalCardAPI.Request.CreationParameters,
                            completion: @escaping (Result<APIResponse<VoidResponseData>, Error>) -> Void) -> DataRequest {

        let router = CardsRouter.createPersonalCard(parameters: parameters)
        return performRequest(router: router, completion: completion)
    }

}

// MARK: - ContentManagerRouter requests
extension APIClient {

    /**
     Request upload image data to server

     - parameters:
        - imageData: image data(JPEG preffered)
        - completion: parsed  'FileAPIResponseData' response from server
     */
    @discardableResult
    func upload(imageData: Data, completion: @escaping (AFResult<APIResponse<FileAPIResponseData>>) -> Void) -> DataRequest {
        let router = ContentManagerRouter.singleFileUpload

        // FIXME: Fix force unwrap
        let url = router.urlRequest!.url!
        let headers = router.urlRequest?.headers
        return upload(imageData: imageData, to: url, headers: headers, completion: completion)
    }

}
