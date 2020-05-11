//
//  LoggerEventMonitor.swift
//  CoBook
//
//  Created by protas on 3/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

final class LoggerEventMonitor: EventMonitor {

    func requestDidResume(_ request: Request) {
        request.cURLDescription { (description) in
            Log.httpRequest("\(request.description)\n\(description)")
        }
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        if let error = response.error {
            Log.httpRequest("Failed request \(request.description): \(error.localizedDescription)" )
        } else {
            Log.httpRequest("Successed request: \(request.description)")
        }

        if let degubResponseString = response.data?.prettyPrintedJSONString {
            Log.httpRequest("Response data: \n\(degubResponseString)")
        }
    }


}
