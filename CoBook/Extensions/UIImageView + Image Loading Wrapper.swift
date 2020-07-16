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
            return
        }
        
        let options = ImageLoadingOptions(
            placeholder: placeholderImage,
            transition: .fadeIn(duration: 0.3)
        )
        
        Nuke.loadImage(with: url, options: options, into: self, completion: completion)
    }
    
    
}
