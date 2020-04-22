//
//  CardBackgroundManagmentTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import AlamofireImage

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
                photoStatusLabel.text = "Змінити фото обкладинки"
                photoStatusLabel.textColor = UIColor.white
                photoSizeLabel.text = "(800x260)"
                photoSizeLabel.textColor = UIColor.white
            case .empty:
                photoStatusLabel.text = "Додати фото обкладинки"
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

    override func prepareForReuse() {
        super.prepareForReuse()
        bgImageView.cancelImageRequest()
        bgImageView.image = nil
        photoStatusLabel.text = ""
        photoSizeLabel.text = ""
    }

    @IBAction func changePhotoTapped(_ sender: Any) {
        delegate?.didChangeBackgroundPhoto(self)
    }

    func set(image: UIImage?) {
        bgImageView.image = image
        currentState = image == nil ? .empty : .filled
    }

    func set(imagePath: String?) {
        if let url = URL(string: imagePath ?? "") {
            bgImageView?.af.setImage(withURL: url) { [weak self] (response) in
                self?.currentState = response.value == nil ? .empty : .filled
            }
        } else {
            currentState = .empty
        }
    }
    
}
