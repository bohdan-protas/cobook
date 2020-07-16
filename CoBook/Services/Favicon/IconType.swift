//
//  RegularExpression.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "renamed to IconType")
public typealias DetectedIconType = IconType

/// Enumerates the types of detected icons.
public enum IconType: UInt {
    /// A shortcut icon.
    case shortcut
    /// A classic icon (usually in the range 16x16 to 48x48).
    case classic
    /// A Google TV icon.
    case googleTV
    /// An icon used by Chrome/Android.
    case googleAndroidChrome
    /// An icon used by Safari on OS X for tabs.
    case appleOSXSafariTab
    /// An icon used iOS for Web Clips on home screen.
    case appleIOSWebClip
    /// An icon used for a pinned site in Windows.
    case microsoftPinnedSite
    /// An icon defined in a Web Application Manifest JSON file, mainly Android/Chrome.
    case webAppManifest
    /// An icon defined by the og:image meta property.
    case openGraphImage
}


