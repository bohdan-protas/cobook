//
//  TimeInterval + Extensions.swift
//  CoBook
//
//  Created by protas on 2/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

extension TimeInterval {
    var minuteSecond: String {
        return String(format:"%d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
