//
//  CardAvatarPhotoManagmentTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Nuke

protocol CardAvatarPhotoManagmentTableViewCellDelegate: class {
    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell)
}

class CardAvatarPhotoManagmentTableViewCell: UITableViewCell {

    enum SourceType {
        case personalCard, businessCard, account

        var selectedStateTitle: String {
            switch self {
            case .personalCard, .account:
                return "Button.changePhoto.normalTitle".localized
            case .businessCard:
                return "Button.changeLogo.normalTitle".localized
            }
        }

        var emptyStateTitle: String {
            switch self {
            case .personalCard, .account:
                return "Button.addPhoto.normalTitle".localized
            case .businessCard:
                return "Button.addLogo.normalTitle".localized
            }
        }

        var titleColor: UIColor {
            switch self {
            case .personalCard, .account:
                return UIColor.Theme.blackMiddle
            case .businessCard:
                return UIColor.Theme.greenDark
            }
        }
    }

    // MARK: - Properties

    @IBOutlet var avatarPaddingConstaints: [NSLayoutConstraint]!
    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var avatarSelectionButton: DesignableButton!

    weak var delegate: CardAvatarPhotoManagmentTableViewCellDelegate?

    private var sourceType: SourceType? {
        didSet {
            avatarSelectionButton.setTitle(sourceType?.selectedStateTitle, for: .selected)
            avatarSelectionButton.setTitle(sourceType?.emptyStateTitle, for: .normal)
            avatarSelectionButton.setTitleColor(sourceType?.titleColor, for: .normal)
            avatarSelectionButton.setTitleColor(sourceType?.titleColor, for: .selected)
        }
    }

    // MARK: - Actions

    @IBAction func avatarSelectionAction(_ sender: UIButton) {
        delegate?.didChangeAvatarPhoto(self)
    }

    // MARK: - Public

    func set(sourceType: SourceType) {
        self.sourceType = sourceType
    }

    func set(imagePath: String?) {
        guard let str = imagePath else {
            avatarImageView.image = UIImage(named: "ic_user")
            self.avatarSelectionButton.isSelected = false
            return
        }
        
        avatarImageView.setImage(withPath: str, placeholderImage: UIImage(named: "ic_user")) { [weak self] (result) in
            switch result {
            case .success:
                self?.avatarSelectionButton.isSelected = true
            case .failure:
                self?.avatarSelectionButton.isSelected = false
            }
        }
    }
    
    func set(image: UIImage?) {
        avatarImageView.image = image
        avatarSelectionButton.isSelected = image != nil
    }

    
}
