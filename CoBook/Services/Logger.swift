//
//  Logger.swift
//  CoBook
//
//  Created by protas on 03/05/2017.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

func print(_ object: Any) {
    // Only allowing in DEBUG mode
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
