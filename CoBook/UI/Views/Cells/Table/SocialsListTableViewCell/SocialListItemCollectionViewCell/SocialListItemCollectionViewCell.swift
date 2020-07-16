//
//  SocialListItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Nuke

class SocialListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var socialImageView: UIImageView!
    @IBOutlet var socialTitleLabel: UILabel!
    @IBOutlet var borderView: UIView!
    
    private var pendingSocialURL: URL?
    let imagePipeline = ImagePipeline.shared
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.pendingSocialURL = nil
        self.socialTitleLabel.text = ""
        self.borderView.backgroundColor = UIColor.Theme.accent
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pendingSocialURL = nil
        resetSocialImage()
        socialTitleLabel.text = ""
    }

    func configure(with item: Social.ListItem) {
        switch item {
        case .view(let social):
            socialTitleLabel.text = social.title
            
            // Reset to def in url is have unexpected format
            guard let url = social.url else {
                resetSocialImage()
                return
            }
            
            // Check for cached image in memory
            if let cachedImageContainer = imagePipeline.cachedImage(for: url) {
                self.socialImageView.image = cachedImageContainer.image
                self.borderView.backgroundColor = cachedImageContainer.image.averageColor
                return
            }
            
            // Load image from web
            pendingSocialURL = url
            do {
                try FavIcon.fetchIconURLBy(url, width: Int(socialImageView.frame.size.width), height: Int(socialImageView.frame.size.height)) { [weak self] (faviconURL, scanningURL) in
                    if scanningURL == self?.pendingSocialURL {
                        guard let faviconURL = faviconURL else {
                            self?.resetSocialImage()
                            return
                        }
                        
                        let request = ImageRequest(
                            url: faviconURL,
                            options: ImageRequestOptions(
                                filteredURL: url.absoluteString
                            )
                        )
                        
                        self?.imagePipeline.loadImage(with: request) { [weak self] (response) in
                            switch response {
                            case .success(let imageContainer):
                                self?.socialImageView.image = imageContainer.image
                                self?.borderView.backgroundColor = imageContainer.image.averageColor
                            case .failure:
                                self?.resetSocialImage()
                            }
                        }
                    }
                }
            } catch {
                resetSocialImage()
            }
        case .add:
            borderView.backgroundColor = .clear
            socialImageView.image = UIImage(named: "ic_add_item")
            socialTitleLabel.text = "Label.add".localized
        }
    }
    
    private func resetSocialImage() {
        self.socialImageView.image = #imageLiteral(resourceName: "ic_social_default")
        self.borderView.backgroundColor = UIColor.Theme.accent
    }

}
