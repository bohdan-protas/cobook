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

        // FIXME: - Change it to real appstore id
        shareLink.iOSParameters?.appStoreID = "962194608"

        // Android parameters
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.cobook.cobook")

        // Social metatag parameters
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
