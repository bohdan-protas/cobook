//
//  StaticMapConfiguratorService.swift
//  CoBook
//
//  Created by protas on 4/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

class StaticMapConfiguratorService {

    static func constructStaticMapURL(mapSize: CGSize, center placeID: String, callback: ((URL?) -> Void)?) {
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: .all, sessionToken: nil) { (place, error) in
            DispatchQueue.main.async {
                if error != nil {
                    Log.error(error?.localizedDescription ?? "")
                    return
                }

                let placeCoordinate = place?.coordinate
                let url = self.constructStaticMapURL(mapSize: mapSize, center: (latitude: placeCoordinate?.latitude, longitude: placeCoordinate?.longitude))
                callback?(url)
            }
        }
    }


    static func constructStaticMapURL(mapSize: CGSize,
                               center coordinates: (latitude: Double?, longitude: Double?)) -> URL? {

        var mapUrl = Constants.StaticMap.baseURL

        mapUrl.append("&size=\(Int(mapSize.width))x\(Int(mapSize.height))")
        mapUrl.append("&scale=\(2)")
        mapUrl.append("&format=png")

        let marker: String = {
            var marker = "&markers=scale:\(1)%7Cicon:\(Constants.StaticMap.personalCardMarkerURL)"
            if let lt = coordinates.latitude, let ln = coordinates.longitude {
                marker.append("%7C\(lt),\(ln)")
            }
            return marker
        }()

        mapUrl.append(marker)

        /// apiKey
        mapUrl.append("&key=\(Constants.Google.placesApiKey)")

        return URL.init(string: mapUrl)
    }


}
