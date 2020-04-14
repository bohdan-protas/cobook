//
//  CardAvatarPhotoManagmentTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CardAvatarPhotoManagmentTableViewCellDelegate: class {
    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell)
}

class CardAvatarPhotoManagmentTableViewCell: UITableViewCell {

    enum SourceType {
        case personalCard, businessCard

        var selectedStateTitle: String {
            switch self {
            case .personalCard:
                return "Змінити фото"
            case .businessCard:
                return "Змінити логотип компанії"
            }
        }

        var emptyStateTitle: String {
            switch self {
            case .personalCard:
                return "Додати фото"
            case .businessCard:
                return "Добавити логотип компанії"
            }
        }

        var titleColor: UIColor {
            switch self {

            case .personalCard:
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
        guard let str = imagePath, let url = URL.init(string: str) else {
            avatarImageView.image = UIImage(named: "ic_user")
            self.avatarSelectionButton.isSelected = false
            return
        }
        
        avatarImageView.setImage(withURL: url, placeholderImage: UIImage(named: "ic_user")) { response in
            self.avatarSelectionButton.isSelected = response.error == nil
            self.avatarSelectionButton.isSelected = true
        }
    }

    func set(image: UIImage?) {
        avatarImageView.image = image
        avatarSelectionButton.isSelected = image != nil
    }

    
}
