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

    public static var `default`: APIClient = {
        let evaluators = [APIConstants.baseURLPath.host ?? "": DisabledEvaluator()]
        let manager = ServerTrustManager(evaluators: evaluators)
        let session = Session(serverTrustManager: manager)

        let apiClient = APIClient(session: session)
        return apiClient
    }()

    private var session: Session

    private init(session: Session) {
        self.session = session
    }

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

    func signUpInitializationRequest(email: String, telephone: String, firstName: String, lastName: String, completion: @escaping (AFResult<APIResponse<SignInAPIResponseData>>) -> Void) {
        let signUpRouter = SignUpRouter.initializeRequest(email: email, telephone: telephone, firstName: firstName, lastName: lastName)
        performRequest(router: signUpRouter, completion: completion)
    }

}
