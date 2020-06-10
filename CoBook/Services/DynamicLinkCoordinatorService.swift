//
//  DynamicLinkCoordinatorService.swift
//  CoBook
//
//  Created by protas on 5/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

// MARK: - DynamicLinkParameterValueFetcher

struct DynamicLinkParameterValueFetcher {

    private var dynamicLinkQueryItems: [URLQueryItem]?

    // MARK: Lifecycle

    init(dynamicLinkURL: URL?) {
        guard let url = dynamicLinkURL, let dynamicLinkComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        dynamicLinkQueryItems = dynamicLinkComponents.queryItems
    }

    init(dynamicLinkQueryItems: [URLQueryItem]?) {
        self.dynamicLinkQueryItems = dynamicLinkQueryItems
    }

    // MARK: Public

    func fetchValueBy(_ parameterName: Constants.DynamicLinks.QueryName) -> String? {
        return dynamicLinkQueryItems?.first(where: {  $0.name == parameterName.rawValue })?.value
    }

}

// MARK: - DynamicLinkCoordinatorService

struct DynamicLinkCoordinatorService {

    // MARK: Public

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

    // MARK: Privates

    private func recognize(dynamicLinkComponents: URLComponents, matchType: DLMatchType) -> UIViewController? {
        switch matchType {
        case .unique, .default:
            switch Constants.DynamicLinks.Path.init(rawValue: dynamicLinkComponents.path) {
            case .some(let value):

                let parser = DynamicLinkParameterValueFetcher(dynamicLinkQueryItems: dynamicLinkComponents.queryItems)

                switch value {
                case .personalCard:
                    if let value = parser.fetchValueBy(.id), let id = Int(value) {
                        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        personalCardDetailsViewController.presenter = PersonalCardDetailsPresenter(id: id)
                        return personalCardDetailsViewController
                    } else {
                        Log.error("personalCard parse error")
                    }

                case .businessCard:
                    if let value = parser.fetchValueBy(.id), let id = Int(value) {
                        let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        businessCardDetailsViewController.presenter = BusinessCardDetailsPresenter(id: id)
                        return businessCardDetailsViewController
                    } else {
                        Log.error("businessCard parse error")
                    }

                case .article:
                    if let articleID = Int(parser.fetchValueBy(.articleID) ?? ""), let albumID = Int(parser.fetchValueBy(.albumID) ?? "") {
                        let articleDetailsViewController: ArticleDetailsViewController = UIStoryboard.post.initiateViewControllerFromType()
                        articleDetailsViewController.presenter = ArticleDetailsPresenter(albumID: albumID, articleID: articleID)
                        return articleDetailsViewController
                    } else {
                        Log.error("article parse error")
                    }

                case .download:
                    break
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
