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

    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        if let error = response.error {
            Log.error("Failed request \(request.description): \(error.localizedDescription)" )
        } else {
            Log.info("Success request: \(request.description)")
        }

        /// When need find parse error
        //Log.info(response.debugDescription)

        if let degubResponseString = response.data?.prettyPrintedJSONString {
            Log.info("Response data: \n\(degubResponseString)")
        }
    }

}
