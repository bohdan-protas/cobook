//
//  ShareableView.swift
//  CoBook
//
//  Created by protas on 5/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

protocol ShareableView {
    func showShareSheet(path: Constants.DynamicLinks.Path, parameters: [Constants.DynamicLinks.QueryName: String?], dynamicLinkSocialMetaTagParameters: DynamicLinkSocialMetaTagParameters?)
}

fileprivate enum Layout {
    static let maxSocialTitleCount: Int = 64
    static let maxSocialDescrCount: Int = 256
}

extension ShareableView where Self: UIViewController {

    func showShareSheet(path: Constants.DynamicLinks.Path, parameters: [Constants.DynamicLinks.QueryName: String?], dynamicLinkSocialMetaTagParameters: DynamicLinkSocialMetaTagParameters?) {
        var dynamicLink = Constants.DynamicLinks.baseURLPath
        dynamicLink.path = path.rawValue
        dynamicLink.queryItems = [URLQueryItem(name: Constants.DynamicLinks.QueryName.shareableUserID.rawValue, value: AppStorage.User.Profile?.userId)]
        let queryItems: [URLQueryItem] = parameters.enumerated().compactMap { URLQueryItem(name: $0.element.key.rawValue, value: $0.element.value) }
        dynamicLink.queryItems?.append(contentsOf: queryItems)

        guard let dynamicLinkURL = dynamicLink.url else {
            Log.error("Couldnt create share link URL")
            return
        }

        guard let shareLink = DynamicLinkComponents(link: dynamicLinkURL, domainURIPrefix: Constants.DynamicLinks.domainURIPrefix.absoluteString) else {
            Log.error("Couldn create FDL components")
            return
        }

        // iOS parameters
        if let bundleID = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }

        
        shareLink.iOSParameters?.appStoreID = Constants.CoBook.appstoreID
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: Constants.Android.packageName)

        // Social metatag parameters
        let dynamicLinkSocialMetaTagParameters = dynamicLinkSocialMetaTagParameters
        dynamicLinkSocialMetaTagParameters?.title = dynamicLinkSocialMetaTagParameters?.title?[0..<Layout.maxSocialTitleCount]
        dynamicLinkSocialMetaTagParameters?.descriptionText = dynamicLinkSocialMetaTagParameters?.descriptionText?[0..<Layout.maxSocialDescrCount]
        shareLink.socialMetaTagParameters = dynamicLinkSocialMetaTagParameters

        // Shorted links
        shareLink.shorten { (url, warnings, error) in
            if let error = error {
                Log.error(error)
                return
            }
            (warnings ?? []).forEach {
                Log.warning($0)
            }
            guard let url = url else { return }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }


}
