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

    /// Asynchronously downloads an image from the specified URL, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placeholder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter url:                        The URL used for the image request.
    /// - parameter cacheKey:                   An optional key used to identify the image in the cache. Defaults
    ///                                         to `nil`.
    /// - parameter placeholderImage:           The image to be set initially until the image request finished. If
    ///                                         `nil`, the image view will not change its image until the image
    ///                                         request finishes. Defaults to `nil`.
    /// - parameter serializer:                 Image response serializer used to convert the image data to `UIImage`.
    ///                                         Defaults to `nil` which will fall back to the
    ///                                         instance `imageResponseSerializer` set on the `ImageDownloader`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///
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

    /// Asynchronously downloads an image from the specified URL, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placeholder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter url:                        The URL used for the image request.
    /// - parameter cacheKey:                   An optional key used to identify the image in the cache. Defaults
    ///                                         to `nil`.
    /// - parameter placeholderImage:           The image to be set initially until the image request finished. If
    ///                                         `nil`, the image view will not change its image until the image
    ///                                         request finishes. Defaults to `nil`.
    /// - parameter serializer:                 Image response serializer used to convert the image data to `UIImage`.
    ///                                         Defaults to `nil` which will fall back to the
    ///                                         instance `imageResponseSerializer` set on the `ImageDownloader`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///
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

    /// Asynchronously downloads an image from the specified URL, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placeholder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter url:                        The URL used for the image request.
    /// - parameter cacheKey:                   An optional key used to identify the image in the cache. Defaults
    ///                                         to `nil`.
    /// - parameter placeholderText:            Text placeholder, shown on image. Defaults to `nil`
    /// - parameter serializer:                 Image response serializer used to convert the image data to `UIImage`.
    ///                                         Defaults to `nil` which will fall back to the
    ///                                         instance `imageResponseSerializer` set on the `ImageDownloader`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///
    public func setImage(withURL url: URL?,
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

    /// Asynchronously downloads an image from the specified URL, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placeholder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter url:                        The URL used for the image request.
    /// - parameter cacheKey:                   An optional key used to identify the image in the cache. Defaults
    ///                                         to `nil`.
    /// - parameter placeholderText:            Text placeholder, shown on image. Defaults to `nil`
    /// - parameter serializer:                 Image response serializer used to convert the image data to `UIImage`.
    ///                                         Defaults to `nil` which will fall back to the
    ///                                         instance `imageResponseSerializer` set on the `ImageDownloader`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///
    public func setImage(withPath string: String?,
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
