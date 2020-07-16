//
//  UIImageView + Extensions.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    
    public func setImage(withPath string: String?,
                         placeholderImage: UIImage? = nil,
                         completion: ImageTask.Completion? = nil) {

        guard let stringPath = string, let url = URL.init(string: stringPath) else {
            self.image = placeholderImage
            completion?(.failure(ImagePipeline.Error.dataLoadingFailed(NSError.instantiate(code: -1, localizedMessage: "URL have unexpected format"))))
            return
        }
        
        let options = ImageLoadingOptions(
            placeholder: placeholderImage,
            transition: .fadeIn(duration: 0.3)
        )
        
        Nuke.loadImage(with: url, options: options, into: self, completion: completion)
    }
    
    
    public func setImage(withURL url: URL?,
                         placeholderImage: UIImage? = nil,
                         completion: ImageTask.Completion? = nil) {
        
        let options = ImageLoadingOptions(
            placeholder: placeholderImage,
            transition: .fadeIn(duration: 0.3)
        )
        
        guard let url = url else {
            self.image = placeholderImage
            completion?(.failure(ImagePipeline.Error.dataLoadingFailed(NSError.instantiate(code: -1, localizedMessage: "URL have unexpected format"))))
            return
        }
        
        Nuke.loadImage(with: url, options: options, into: self, completion: completion)
    }
    
    
}
