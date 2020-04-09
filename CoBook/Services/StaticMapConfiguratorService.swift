//
//  StaticMapConfiguratorService.swift
//  CoBook
//
//  Created by protas on 4/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class StaticMapConfiguratorService {

        func constructStaticMapURL(mapSize: CGSize) -> URL? {

    //        /// generate static map url marker
    //        func generateMapMarkerURL(category: HopCategory, number: Int, using paths: PhotobookMapIcons.Paths) -> String {
    //            var categoryUrlPath = paths.otherCategory
    //            switch category {
    //            case .activity:
    //                categoryUrlPath = paths.doCategory
    //            case .meal:
    //                categoryUrlPath = paths.eatCategory
    //            case .lodging:
    //                categoryUrlPath = paths.stayCategory
    //            case .transit:
    //                categoryUrlPath = paths.goCategory
    //            case .none:
    //                categoryUrlPath = paths.otherCategory
    //            }
    //
    //            return paths.urlPrefix + categoryUrlPath + paths.iconFilePrefix + "\(number)" + paths.iconFileSuffix
    //        }

            var mapUrl = "https://maps.googleapis.com/maps/api/staticmap?"

            mapUrl.append("&size=\(Int(mapSize.width))x\(Int(mapSize.height))")
            mapUrl.append("&scale=2")
            mapUrl.append("&format=png")

    //        /// setup map center
    //        let mapCenter = hops
    //            .compactMap { $0.location }
    //            .max { Float($0.longitude) < Float($1.longitude) }

    //        if let mapCenter = mapCenter {
    //            mapUrl.append("&center=\(mapCenter.latitude),\(mapCenter.longitude)")
    //        }

    //        /// Setup markers
    //        for (index, hop) in hops.enumerated() {
    //            guard let lt = hop.location?.latitude, let lg = hop.location?.longitude
    //            else {
    //                emptyMapCallback()
    //                continue
    //            }
    //
    //            mapUrl.append(
    //                "&markers=scale:2%7Cicon:\(generateMapMarkerURL(category: hop.hopCategory, number: index + startingOrderNumber, using: iconPaths))"
    //                + "%7C\(lt),\(lg)"
    //            )
    //        }

            /// apiKey
            mapUrl.append("&key=\(APIConstants.Google.placesApiKey)")

            return URL.init(string: mapUrl)
        }


}
