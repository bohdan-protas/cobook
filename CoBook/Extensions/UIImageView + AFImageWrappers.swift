//
//  UIImageView + Extensions.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {

    public func setImage(withPath string: String?,
                         placeholderImage: UIImage? = nil,
                         imageTransition: UIImageView.ImageTransition = .noTransition,
                         completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {

        guard let stringPath = string, let url = URL.init(string: stringPath) else {
            self.image = placeholderImage
            return
        }

        af.setImage(withURL: url,
                    cacheKey: stringPath,
                    placeholderImage: placeholderImage,
                    serializer: nil,
                    filter: nil,
                    progress: nil,
                    progressQueue: DispatchQueue.main,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: false,
                    completion: completion)
    }

    func cancelImageRequest() {
        af.cancelImageRequest()
    }


}
