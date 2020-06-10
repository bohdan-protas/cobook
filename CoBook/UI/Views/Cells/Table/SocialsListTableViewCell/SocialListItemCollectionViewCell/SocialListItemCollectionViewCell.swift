//
//  SocialListItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SocialListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var socialImageView: UIImageView! {
        didSet {
            borderView.backgroundColor = socialImageView.image?.averageColor
        }
    }
    @IBOutlet var socialTitleLabel: UILabel!
    @IBOutlet var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        socialTitleLabel.text = ""
        socialImageView.image = #imageLiteral(resourceName: "ic_social_default")
        borderView.backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        socialTitleLabel.text = ""
        borderView.backgroundColor = .clear

        pendingRequestWorkItem?.cancel()
        socialImageView.af.cancelImageRequest()
        socialImageView.image = #imageLiteral(resourceName: "ic_social_default")
    }

    private var pendingRequestWorkItem: DispatchWorkItem?

    func configure(with item: Social.ListItem) {
        switch item {
        case .view(let social):
            socialTitleLabel.text = social.title
            if let type = social.type {
                socialImageView.image = type.image
                borderView.backgroundColor = type.image.averageColor
            } else {
                if let url = social.url {
                    pendingRequestWorkItem = OpenGraphFetcher().fetchOpenGraphImage(from: url, completion: { [weak self] (result) in
                        switch result {
                        case .success(let imageUrl):
                            if let url = URL.init(string: imageUrl ?? "") {
                                self?.socialImageView.af.setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "ic_social_default")) { [weak self] (response) in
                                    self?.borderView.backgroundColor = response.value?.averageColor
                                }
                            }
                        case .failure(let error):
                            Log.error(error.localizedDescription)
                        }
                    })
                }
            }
        case .add:
            borderView.backgroundColor = .clear
            socialImageView.image = UIImage(named: "ic_add_item")
            socialTitleLabel.text = "Додати"
        }
    }

}
