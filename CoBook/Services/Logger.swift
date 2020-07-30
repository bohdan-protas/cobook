//
//  Logger.swift
//  CoBook
//
//  Created by protas on 03/05/2017.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Firebase

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

class Log {
    
    enum Event: String {
        case error          = "[‼️]" // error
        case info           = "[ℹ️]" // info
        case debug          = "[💬]" // debug
        case warning        = "[⚠️]" // warning
        case httpRequest    = "[🌏]" // httpRequest
    }
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    class func error( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Log.Event.error.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]: [\(funcName) \(line) \(column)] -> \(object)")
        }
    }
    
    class func info( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Log.Event.info.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))] -> \(object)")
        }
    }
    
    class func debug( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Log.Event.debug.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]: \(funcName) [\(line) \(column)] -> \(object)")
        }
    }
    
    class func warning( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Log.Event.warning.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]: \(funcName) [\(line) \(column)] -> \(object)")
        }
    }
    
    class func httpRequest( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Log.Event.httpRequest.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))] -> \(object)")
        }
    }
    
    enum Firebase {
        
        enum EventParameter {
            
            enum Name {
                static let firstName: String = "first_name"
                static let lastName: String = "last_name"
                static let telephone: String = "telephone"
                static let userID: String = "user_id"
                static let name: String = "name"
                static let purchaseType: String = "purchase_type"
                static let price: String = "price"
                static let id: String = "id"
                static let billID: String = "bill_id"
            }
            
            enum Value {
                static let franshise: String = "franchise"
                static let businessCard: String = "business_card"
            }
            
        }
                
        static func businessCardPurchase(billID: String?, value: String?) {
            Analytics.logEvent(AnalyticsEventPurchase,
                               parameters: [
                                EventParameter.Name.purchaseType: EventParameter.Value.businessCard,
                                EventParameter.Name.billID: billID ?? "Undefined",
                                AnalyticsParameterValue: value ?? "Undefined"
            ])
        }
        
        static func franchisePurchase(billID: String?, value: String?) {
            Analytics.logEvent(AnalyticsEventPurchase,
                               parameters: [
                                EventParameter.Name.purchaseType: EventParameter.Value.franshise,
                                EventParameter.Name.billID: billID ?? "Undefined",
                                AnalyticsParameterValue: value ?? "Undefined"
            ])
        }
        
        static func signUp(userID: String?, name: String?, telephone: String?) {
            Analytics.logEvent(AnalyticsEventSignUp,
                               parameters: [
                                EventParameter.Name.name: name ?? "Undefined",
                                EventParameter.Name.telephone: telephone ?? "Undefined",
                                EventParameter.Name.userID: userID ?? "Undefined"
            ])
        }
        
        static func login(userID: String?, name: String?, telephone: String?) {
            Analytics.logEvent(AnalyticsEventLogin,
                               parameters: [
                                EventParameter.Name.name: name ?? "Undefined",
                                EventParameter.Name.telephone: telephone ?? "Undefined",
                                EventParameter.Name.userID: userID ?? "Undefined"
            ])
        }
    }
    
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
