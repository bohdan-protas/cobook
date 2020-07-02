//
//  PaymentStatus.swift
//  CoBook
//
//  Created by Bogdan Protas on 29.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CardPublishStatus {
    case expired
    case actived
    
    var description: String {
        switch self {
            
        case .expired:
            return "Payment.status.notPublished.title".localized
        case .actived:
            return "Payment.status.published.title".localized
        }
    }
    
    var color: UIColor {
        switch self {
        case .expired:
            return UIColor.red
        case .actived:
            return UIColor.Theme.green
        }
    }
    
}
