//
//  QRCodeViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class QRCodeViewController: BaseViewController, ShareableView {

    @Localized("QRCode.qrInfo.title") @IBOutlet var qrCodeTitleLabel: UILabel!
    @Localized("QRCode.qrInfo.body") @IBOutlet var qrCodeDescriptionLabel: UILabel!
    @Localized("QRCode.referalInfo.title") @IBOutlet var referalLinkTitleLabel: UILabel!
    @Localized("QRCode.referalInfo.body") @IBOutlet var referalLinkDescriptionLabel: UILabel!
    
    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet var referalLinkButton: LoaderDesignableButton!
    @IBOutlet var qrImageLoader: UIActivityIndicatorView!
    
    private var shortenReferalLink: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "QRCode.title".localized
        
        setup()
    }
    
    // MARK: - Actions
    
    @IBAction func referalLinkButtonTapped(_ sender: Any) {
        if let url = shortenReferalLink {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func setup() {
        
        qrImageLoader.startAnimating()
        
        let socialMetaTags = DynamicLinkSocialMetaTagParameters()
        socialMetaTags.imageURL = Constants.CoBook.logoURL
        socialMetaTags.title = "Social.metaTag.inviteFriends.title".localized
        socialMetaTags.descriptionText = "Social.metaTag.inviteFriends.description".localized
        
        let result = generateLink(path: .download, dynamicLinkSocialMetaTagParameters: socialMetaTags, parameters: [:])
        if let error = result.error {
            errorAlert(message: error.localizedDescription)
        } else {
            // Shorted links
            result.link?.shorten { (url, warnings, error) in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                    return
                }
                (warnings ?? []).forEach {
                    Log.warning($0)
                }
                guard let url = url else { return }
                self.shortenReferalLink = url
                self.referalLinkButton.setTitle(url.absoluteString, for: .normal)
                self.qrCodeImageView.image = self.generateQRCode(from: url.absoluteString)
                self.qrImageLoader.stopAnimating()
            }
            
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}
