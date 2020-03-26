//
//  CardAvatarPhotoManagmentTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CardAvatarPhotoManagmentTableViewCellDelegate: class {
    func cardAvatarPhotoManagmentView(_ view: CardAvatarPhotoManagmentTableViewCell, didSelectAction sender: UIButton)
    func cardAvatarPhotoManagmentView(_ view: CardAvatarPhotoManagmentTableViewCell, didChangeAction sender: UIButton)
}

class CardAvatarPhotoManagmentTableViewCell: UITableViewCell {

    enum SourceType {
        case personalCard, businessCard

        var selectedStateTitle: String {
            switch self {
            case .personalCard:
                return "Змінити фото"
            case .businessCard:
                return "Змінити фото"
            }
        }

        var emptyStateTitle: String {
            switch self {
            case .personalCard:
                return "Додати фото"
            case .businessCard:
                return "Додати фото"
            }
        }
    }

    // MARK: Properties
    @IBOutlet var avatarPaddingConstaints: [NSLayoutConstraint]!
    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var avatarSelectionButton: DesignableButton!

    weak var delegate: CardAvatarPhotoManagmentTableViewCellDelegate?

    private var sourceType: SourceType? {
        didSet {
            avatarSelectionButton.setTitle(sourceType?.selectedStateTitle, for: .selected)
            avatarSelectionButton.setTitle(sourceType?.emptyStateTitle, for: .normal)
        }
    }

    @IBAction func avatarSelectionAction(_ sender: UIButton) {
        if sender.isSelected {
            delegate?.cardAvatarPhotoManagmentView(self, didChangeAction: sender)
        } else {
            delegate?.cardAvatarPhotoManagmentView(self, didSelectAction: sender)
        }
    }

    // MARK: Public
    func fill(sourceType: SourceType, imagePath: String?) {
        self.sourceType = sourceType

        guard let str = imagePath, let url = URL.init(string: str) else {
            avatarImageView.image = UIImage(named: "ic_user")
            self.avatarSelectionButton.isSelected = false
            return
        }
        
        avatarImageView.setImage(withURL: url, placeholderImage: UIImage(named: "ic_user")) { response in
            self.avatarSelectionButton.isSelected = response.error == nil
        }
    }

    
}
