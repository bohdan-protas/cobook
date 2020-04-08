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
                         cacheKey: String? = nil,
                         placeholderImage: UIImage? = nil,
                         serializer: ImageResponseSerializer? = nil,
                         filter: ImageFilter? = nil,
                         progress: ImageDownloader.ProgressHandler? = nil,
                         progressQueue: DispatchQueue = DispatchQueue.main,
                         imageTransition: UIImageView.ImageTransition = .noTransition,
                         runImageTransitionIfCached: Bool = false,
                         completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {

        guard let stringPath = string, let url = URL.init(string: stringPath) else {
            self.image = placeholderImage
            return
        }

        af.setImage(withURL: url,
                    cacheKey: cacheKey,
                    placeholderImage: placeholderImage,
                    serializer: serializer,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }

    public func setImage(withURL url: URL?,
                         cacheKey: String? = nil,
                         placeholderImage: UIImage? = nil,
                         serializer: ImageResponseSerializer? = nil,
                         filter: ImageFilter? = nil,
                         progress: ImageDownloader.ProgressHandler? = nil,
                         progressQueue: DispatchQueue = DispatchQueue.main,
                         imageTransition: UIImageView.ImageTransition = .noTransition,
                         runImageTransitionIfCached: Bool = false,
                         completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {

        guard let url = url else {
            self.image = placeholderImage
            return
        }

        af.setImage(withURL: url,
                    cacheKey: cacheKey,
                    placeholderImage: placeholderImage,
                    serializer: serializer,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }


    public func setTextPlaceholderImage(withURL url: URL?,
                         cacheKey: String? = nil,
                         placeholderText: String? = nil,
                         serializer: ImageResponseSerializer? = nil,
                         filter: ImageFilter? = nil,
                         progress: ImageDownloader.ProgressHandler? = nil,
                         progressQueue: DispatchQueue = DispatchQueue.main,
                         imageTransition: UIImageView.ImageTransition = .noTransition,
                         runImageTransitionIfCached: Bool = false,
                         completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {

        (self as? DesignableTextPlaceholderImageView)?.placeholder = placeholderText

        guard let url = url else {
            self.image = nil
            return
        }

        af.setImage(withURL: url,
                    cacheKey: cacheKey,
                    placeholderImage: nil,
                    serializer: serializer,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }

    public func setTextPlaceholderImage(withPath string: String?,
                         cacheKey: String? = nil,
                         placeholderText: String? = nil,
                         serializer: ImageResponseSerializer? = nil,
                         filter: ImageFilter? = nil,
                         progress: ImageDownloader.ProgressHandler? = nil,
                         progressQueue: DispatchQueue = DispatchQueue.main,
                         imageTransition: UIImageView.ImageTransition = .noTransition,
                         runImageTransitionIfCached: Bool = false,
                         completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {

        (self as? DesignableTextPlaceholderImageView)?.placeholder = placeholderText

        guard let stringPath = string, let url = URL.init(string: stringPath) else {
            self.image = nil
            return
        }


        af.setImage(withURL: url,
                    cacheKey: cacheKey,
                    placeholderImage: nil,
                    serializer: serializer,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }

    func cancelImageRequest() {
        af.cancelImageRequest()
    }


}
