//
//  ArticleHeaderTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol ArticleHeaderTableViewCellDelegate: class {
    func moreButtonAction(_ cell: ArticleHeaderTableViewCell)
}

class ArticleHeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var viewsCountLabel: UILabel!
    @IBOutlet var moreButton: UIButton!

    weak var delegate: ArticleHeaderTableViewCellDelegate?

    @IBAction func moreButtonTapped(_ sender: Any) {
        self.delegate?.moreButtonAction(self)
    }

    
}
