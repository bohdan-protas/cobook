//
//  PersonalCardUserInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PersonalCardUserInfoTableViewCellDelegate: class {
    func onSaveCard(cell: PersonalCardUserInfoTableViewCell)
    func onOpenCompany(_ cell: PersonalCardUserInfoTableViewCell)
}

class PersonalCardUserInfoTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var practiceTypeLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var detailInfoTextView: DesignableTextView!
    @IBOutlet var saveButton: DesignableButton!
    @IBOutlet var userInfoContainer: UIView!

    weak var delegate: PersonalCardUserInfoTableViewCellDelegate?

    private var company: String?
    
    
    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        delegate?.onSaveCard(cell: self)
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        clearLayout()

        userInfoContainer.clipsToBounds = true
        userInfoContainer.layer.cornerRadius = 10
        userInfoContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCompanyTapped))
        positionLabel.addGestureRecognizer(tap)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearLayout()
    }
    
    // MARK: - Actions
    
    @objc func handleCompanyTapped(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: positionLabel)
        let index = positionLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        guard let companyText = company else {
            return
        }
        
        let positionFullStr: NSString = (positionLabel.text ?? "") as NSString
        let companyRange = positionFullStr.range(of: companyText)
        if checkRange(companyRange, contain: index) {
            delegate?.onOpenCompany(self)
        }
    }
    
    // MARK: - Public
    
    func set(position: String?, company: String?) {
        guard let company = company else {
            self.positionLabel.text = position
            return
        }
        
        self.company = company
        let positionAndCompanyText = "\(position ?? "") \("Label.in".localized) \(company)"
        let formattedText = String.format(strings: [company],
                                          boldFont: UIFont.HelveticaNeueCyr_Bold(size: 15),
                                          boldColor: UIColor.Theme.green,
                                          inString: positionAndCompanyText,
                                          font: UIFont.HelveticaNeueCyr_Roman(size: 15),
                                          color: UIColor.Theme.blackMiddle)
        self.positionLabel.attributedText = formattedText
        
    }
    
    // MARK: - Helpers

    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
    
}

// MARK: - PersonalCardUserInfoTableViewCell

private extension PersonalCardUserInfoTableViewCell {
    
    func clearLayout() {
        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
        company = nil
    }


}
