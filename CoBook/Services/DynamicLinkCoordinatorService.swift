//
//  DynamicLinkCoordinatorService.swift
//  CoBook
//
//  Created by protas on 5/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class DynamicLinkCoordinatorService {

    func recognizeControllerFrom(dynamicLink: DynamicLinkContainer) -> UIViewController? {
        guard let url = dynamicLink.url, let dynamicLinkComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let matchTypeInteger = dynamicLink.matchType else {
            return nil
        }
        return recognize(dynamicLinkComponents: dynamicLinkComponents, matchType: DLMatchType(rawValue: matchTypeInteger) ?? DLMatchType.none)
    }

    func recognizeControllerFrom(dynamicLink: DynamicLink) -> UIViewController? {
        guard let url = dynamicLink.url, let dynamicLinkComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return recognize(dynamicLinkComponents: dynamicLinkComponents, matchType: dynamicLink.matchType)
    }


}

// MARK: - Privates

private extension DynamicLinkCoordinatorService {

    func recognize(dynamicLinkComponents: URLComponents, matchType: DLMatchType) -> UIViewController? {
        switch matchType {
        case .unique, .default:
            switch DynamicLinkParameter.Path.init(rawValue: dynamicLinkComponents.path) {
            case .some(let value):
                switch value {
                case .personalCard:
                    if let idQuery = dynamicLinkComponents.queryItems?.first(where: {  $0.name == DynamicLinkParameter.QueryName.id.rawValue }) {
                        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        personalCardDetailsViewController.presenter = PersonalCardDetailsPresenter(id: Int(idQuery.value ?? "") ?? -1)
                        return personalCardDetailsViewController
                    }
                case .businessCard:
                    if let idQuery = dynamicLinkComponents.queryItems?.first(where: {  $0.name == DynamicLinkParameter.QueryName.id.rawValue }) {
                        let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        businessCardDetailsViewController.presenter = BusinessCardDetailsPresenter(id: Int(idQuery.value ?? "") ?? -1)
                        return businessCardDetailsViewController
                    }
                case .article:
                    if let articleIDQuery = dynamicLinkComponents.queryItems?.first(where: {  $0.name == DynamicLinkParameter.QueryName.articleID.rawValue }),
                        let albumIDQuery = dynamicLinkComponents.queryItems?.first(where: {  $0.name == DynamicLinkParameter.QueryName.albumID.rawValue }) {
                        let articleDetailsViewController: ArticleDetailsViewController = UIStoryboard.post.initiateViewControllerFromType()
                        articleDetailsViewController.presenter = ArticleDetailsPresenter(albumID: Int(albumIDQuery.value ?? "") ?? -1, articleID: Int(articleIDQuery.value ?? "") ?? -1)
                        return articleDetailsViewController
                    }
                }
            case .none:
                break
            }
        default:
            break
        }
        return nil
    }


}
