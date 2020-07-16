//
//  CardBackgroundManagmentTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Nuke

protocol CardBackgroundManagmentTableViewCellDelegate: class {
    func didChangeBackgroundPhoto(_ view: CardBackgroundManagmentTableViewCell)
}

class CardBackgroundManagmentTableViewCell: UITableViewCell {

    enum State {
        case filled
        case empty
    }

    @IBOutlet var photoSizeLabel: UILabel!
    @IBOutlet var photoStatusLabel: UILabel!
    @IBOutlet var bgImageView: UIImageView!

    weak var delegate: CardBackgroundManagmentTableViewCellDelegate?
    var currentState: State = .empty {
        didSet {
            switch currentState {
            case .filled:
                photoStatusLabel.text = "Label.changeBgPhoto.text".localized
                photoStatusLabel.textColor = UIColor.white
                photoSizeLabel.text = "(800x260)"
                photoSizeLabel.textColor = UIColor.white
            case .empty:
                photoStatusLabel.text = "Label.addBgPhoto.text".localized
                photoStatusLabel.textColor = UIColor.Theme.greenDark
                photoSizeLabel.text = "(800x260)"
                photoSizeLabel.textColor = UIColor.Theme.greenDark
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        currentState = .empty
    }

    // MARK: - Actions
    
    @IBAction func changePhotoTapped(_ sender: Any) {
        delegate?.didChangeBackgroundPhoto(self)
    }

    // MARK: - Public
    
    func set(image: UIImage?) {
        bgImageView.image = image
        currentState = image == nil ? .empty : .filled
    }

    func set(imagePath: String?) {
        if let url = URL(string: imagePath ?? "") {
            Nuke.loadImage(with: url, into: bgImageView) { (result) in
                switch result {
                case .success:
                    self.currentState = .filled
                case .failure:
                    self.currentState = .empty
                }
            }

        } else {
            currentState = .empty
        }
    }
    
}
