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
    /**
    Base request builder

    - parameters:
       - endpoint: path to endpoint
       - decoder: decoder for decode response, by default JSONDecoder()
       - completion: parsed response from server
    */
    @discardableResult
    private func performRequest<T: Decodable>(endpoint: URLRequestConvertible,
                                              decoder: JSONDecoder = JSONDecoder(),
                                              completion: @escaping (Result<T?, Error>) -> Void) -> DataRequest {

        return session.request(endpoint)
            .validate(statusCode: 200..<300)
            .response { (response) in
                if let responseData = response.data {
                    do {
                        let decodedResponse = try decoder.decode(APIResponse<T>.self, from: responseData)
                        switch decodedResponse.status {
                        case .ok:
                            completion(.success(decodedResponse.data))
                        case .error:
                            let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: decodedResponse.errorLocalizadMessage ?? "Undefined error occured")
                            completion(.failure(error))
                        }
                    } catch let decodeErrror {
                        Log.error(decodeErrror)
                        let userError = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Received data in unexpected format")
                        completion(.failure(userError))
                    }
                } else {
                    let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Something bad happens, try anain later.")
                    completion(.failure(error))
                }
            }
    } // end performRequest

    /**
    Photo upload request

    - parameters:
       - imageData: compressed image data(JPEG preffered)
       - endpoint: path to endpoint
       - headers: headers for authetificate
       - decoder: decoder for decode response, by default JSONDecoder()
       - completion: parsed response from server
    */
    @discardableResult
    private func upload<T: Decodable>(imageData: Data,
                                      to endpoint: URLConvertible,
                                      headers: HTTPHeaders?,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: @escaping (Result<T?, Error>) -> Void) -> DataRequest {

        return session.upload(multipartFormData: { multipartFormData in
            let randomName = "\(String.random())-image"
            multipartFormData.append(imageData, withName: randomName, fileName: "\(randomName).png", mimeType: "image/png")
        }, to: endpoint, headers: headers)
            .response { (response) in
                
                guard let responseData = response.data else {
                    let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Something bad happens, try anain later.")
                    completion(.failure(error))
                    return
                }

                do {
                    let decodedResponse = try decoder.decode(APIResponse<T>.self, from: responseData)
                    switch decodedResponse.status {
                    case .ok:
                        completion(.success(decodedResponse.data))
                    case .error:
                        let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: decodedResponse.errorLocalizadMessage ?? "Undefined error occured")
                        completion(.failure(error))
                    }
                } catch let decodeError {
                    Log.error(decodeError)

                    let error = NSError.instantiate(code: response.response?.statusCode ?? -1, localizedMessage: "Received data in bad format")
                    completion(.failure(error))
                }

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
                                     completion: @escaping (Result<SignInAPIResponseData?, Error>) -> Void) {

        let endpoint = SignUpEndpoint.initialize(email: email, telephone: telephone, firstName: firstName, lastName: lastName)
        performRequest(endpoint: endpoint, completion: completion)
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
                       completion: @escaping (Result<VerifyAPIResponseData?, Error>) -> Void) {

        let endpoint = SignUpEndpoint.verify(smsCode: smsCode, accessToken: accessToken)
        performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request resend sms

     - parameters:
        - accessToken: users access token
        - completion: parsed response from server
     */
    func resendSmsRequest(accessToken: String,
                          completion: @escaping (Result<SignInAPIResponseData?, Error>) -> Void) {

        let endpoint = SignUpEndpoint.resend(accessToken: accessToken)
        performRequest(endpoint: endpoint, completion: completion)
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
                             completion: @escaping (Result<RegisterAPIResponseData?, Error>) -> Void) {

        let endpoint = SignUpEndpoint.finish(accessToken: accessToken, password: password)
        performRequest(endpoint: endpoint, completion: completion)
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
                       completion: @escaping (Result<RegisterAPIResponseData?, Error>) -> Void) {

        let endpoint = SignInEndpoint.login(login: login, password: password)
        performRequest(endpoint: endpoint, completion: completion)
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
    func refreshTokenRequest(refreshToken: String, completion: @escaping (Result<RefreshTokenAPIResponseData?, Error>) -> Void) {
        let endpoint = AuthEndpoint.refresh(refreshToken: refreshToken)
        performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request new credentials via login

     - parameters:
        - telephone: current users telephone number
        - completion: parsed response from server
     */
    func forgotPasswordRequest(telephone: String,
                               completion: @escaping (Result<VoidResponseData?, Error>) -> Void) {

        let endpoint = AuthEndpoint.forgotPassword(telephone: telephone)
        performRequest(endpoint: endpoint, completion: completion)
    }

}

// MARK: - InterestsEndpoint requests
extension APIClient {

    /**
     Request localized list of interests
    */
    func interestsListRequest(completion: @escaping (Result<[InterestApiModel]?, Error>) -> Void) {
        let endpoint = InterestsEndpoint.list
        performRequest(endpoint: endpoint, completion: completion)
    }


}

// MARK: - PracticeTypesEndpoint request
extension APIClient {

    /**
     Request localized list of practice types
    */
    @discardableResult
    func practicesTypesListRequest(completion: @escaping (Result<[PracticeTypeApiModel]?, Error>) -> Void) -> DataRequest{
        let endpoint = PracticeTypesEndpoint.list
        return performRequest(endpoint: endpoint, completion: completion)
    }


}

// MARK: - CardsEndpoint requests
extension APIClient {
    /**
     Request updaet business card
    */
    @discardableResult
    func updateBusinessCard(parameters: CreateBusinessCardParametersApiModel,
                            completion: @escaping (Result<VoidResponseData?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.updateBusinessCard(parameters: parameters)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request create business card
    */
    @discardableResult
    func createBusinessCard(parameters: CreateBusinessCardParametersApiModel,
                            completion: @escaping (Result<VoidResponseData?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.createBusinessCard(parameters: parameters)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request create personal card
    */
    @discardableResult
    func createPersonalCard(parameters: CreatePersonalCardParametersApiModel,
                            completion: @escaping (Result<VoidResponseData?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.createPersonalCard(parameters: parameters)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request for card details info

     - parameters:
        - id: card id
        - completion: parsed  'CardDetailsAPIResponseData' response from server
     - returns: DataRequest
     */
    @discardableResult
    func getCardInfo(id: Int,
                     completion: @escaping (Result<CardDetailsApiModel?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.getCardInfo(id: id)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request for card items list

     - parameters:
        - type: card id
        - interestIds: filter cards by interests ids (default nil)
        - practiseTypeIds: filter cards by practise type ids (default nil)
        - search: query for searching
        - limit: pagination page list limit (default 15)
        - offset: pagination offset (default 0)
        - completion: parsed  'CardItemApiModel'  list response
     - returns: runned DataRequest
     */
    @discardableResult
    func getCardsList(type: String? = nil,
                      interestIds: [Int]? = nil,
                      practiseTypeIds: [Int]? = nil,
                      search: String? = nil,
                      limit: Int? = nil,
                      offset: Int? = nil,
                      completion: @escaping (Result<[CardItemApiModel]?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.getCardsList(type: type, interestsIds: interestIds, practiseTypeIds: practiseTypeIds, search: search, limit: limit, offset: offset)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    /**
     Request for card items list

     - parameters:
        - type: card id
        - limit: pagination page list limit (default 15)
        - offset: pagination offset (default 0)
        - completion: parsed  'CardItemApiModel'  list response
     - returns: runned DataRequest
     */
    @discardableResult
    func getCardLocationsInRegion(topLeftRectCoordinate: CoordinateApiModel,
                                  bottomRightRectCoordinate: CoordinateApiModel,
                                  completion: @escaping (Result<[CardMapMarkerApiModel]?, Error>) -> Void) -> DataRequest {

        let endpoint = CardsEndpoint.getCardLocationsInRegion(topLeftRectCoordinate: topLeftRectCoordinate, bottomRightRectCoordinate: bottomRightRectCoordinate)
        return performRequest(endpoint: endpoint, completion: completion)
    }


}

// MARK: - ContentManagerEndpoint requests
extension APIClient {

    /**
     Request upload image data to server

     - parameters:
        - imageData: image data(JPEG preffered)
        - completion: parsed  'FileAPIResponseData' response from server
     */
    @discardableResult
    func upload(imageData: Data,
                completion: @escaping (Result<FileDataApiModel?, Error>) -> Void) -> DataRequest {

        let endpoint = ContentManagerEndpoint.singleFileUpload
        let url = endpoint.urlRequest!.url!
        let headers = endpoint.urlRequest?.headers
        return upload(imageData: imageData, to: url, headers: headers, completion: completion)
    }

}

// MARK: - ProfileEndpoint requests
extension APIClient {

    /**
     Request get profile data

     - parameters:
        - imageData: image data(JPEG preffered)
        - completion: parsed  'FileAPIResponseData' response from server
     */
    @discardableResult
    func profileDetails(completion: @escaping (Result<ProfileApiModel?, Error>) -> Void) -> DataRequest {
        let endpoint = ProfileEndpoint.profile
        return performRequest(endpoint: endpoint, completion: completion)
    }

}

// MARK: - UsersEndpoint requests
extension APIClient {

    @discardableResult
    func searchEmployee(searchQuery: String?,
                     limit: Int? = nil,
                     offset: Int? = nil,
                     completion: @escaping (Result<[EmployersSearchItemApiModel]?, Error>) -> Void) -> DataRequest {

        let endpoint = UsersEndpoint.searchEmployee(searchQuery: searchQuery, limit: limit, offset: offset)
        return performRequest(endpoint: endpoint, completion: completion)
    }

    @discardableResult
    func employeeList(cardId: Int,
                      limit: Int? = nil,
                      offset: Int? = nil,
                      completion: @escaping (Result<[EmployApiModel]?, Error>) -> Void) -> DataRequest {

        let endpoint = UsersEndpoint.employeeList(cardId: cardId, limit: limit, offset: offset)
        return performRequest(endpoint: endpoint, completion: completion)
    }


}
