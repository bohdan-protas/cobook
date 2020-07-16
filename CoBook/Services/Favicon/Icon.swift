//
//  RegularExpression.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

/// Represents a detected icon.
public struct Icon {
    /// The absolute URL for the icon file.
    public let url: URL
    /// The type of the icon.
    public let type: IconType
    /// The width of the icon, if known, in pixels.
    public let width: Int?
    /// The height of the icon, if known, in pixels.
    public let height: Int?

    init(url: URL, type: IconType, width: Int? = nil, height: Int? = nil) {
        self.url = url
        self.type = type
        self.width = width
        self.height = height
    }
}
