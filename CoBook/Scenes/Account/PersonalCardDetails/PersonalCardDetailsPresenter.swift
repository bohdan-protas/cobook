//
//  PersonalCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

protocol PersonalCardDetailsView: class, AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView, ShareableView {
    func setupLayout()
    func set(dataSource: TableDataSource<PersonalCardDetailsDataSourceConfigurator>?)
    func reload()
    func setupEditView()
    func setupEmptyBottomView()
    func goToArticleDetails(presenter: ArticleDetailsPresenter)
    func goToCreatePost(cardID: Int)
}

class PersonalCardDetailsPresenter: NSObject, BasePresenter {

    /// managed veiw
    private weak var view: PersonalCardDetailsView?

    private var personalCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var dataSource: TableDataSource<PersonalCardDetailsDataSourceConfigurator>?
    private var albumPreviewSection: PostPreview.Section?

    /// Flag for owner identifire
    private var isUserOwner: Bool {
        return AppStorage.User.Profile?.userId == cardDetails?.cardCreator?.id
    }

    // MARK: - Lifecycle

    init(id: Int) {
        self.personalCardId = id
        super.init()
        self.dataSource = TableDataSource(configurator: self.dataSourceConfigurator)
    }

    // MARK: - Public

    func attachView(_ view: PersonalCardDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func setupDataSource() {
        let group = DispatchGroup()
        var errors = [Error]()
        var items: [PostPreview.Item] = []
        view?.startLoading()

        // fetch card details
        group.enter()
        APIClient.default.getCardInfo(id: personalCardId) { [weak self] (result) in
            self?.view?.stopLoading()
            switch result {
            case .success(let response):
                self?.cardDetails = response
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch albums list
        group.enter()
        APIClient.default.getAlbumsList(cardID: personalCardId) { (result) in
            switch result {
            case .success(let response):
                let albumPreviewItems = response?.compactMap { PostPreview.Item.Model(albumID: $0.id,
                                                                                              title: $0.title,
                                                                                              avatarPath: $0.avatar?.sourceUrl,
                                                                                              avatarID: $0.avatar?.id) } ?? []
                items = albumPreviewItems.compactMap { PostPreview.Item.view($0) }
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            /// Errors handling
            errors.forEach {
                strongSelf.view?.errorAlert(message: $0.localizedDescription)
            }

            /// Datasource configuration
            if strongSelf.isUserOwner {
                items.insert(.add(title: "PersonalCard.createNewAlbum.text".localized, imagePath: strongSelf.cardDetails?.avatar?.sourceUrl), at: 0)
            }
            strongSelf.albumPreviewSection = PostPreview.Section(dataSourceID: PersonalCardDetails.DataSourceID.albumPreviews.rawValue, items: items)
            strongSelf.view?.setupLayout()
            strongSelf.view?.set(dataSource: strongSelf.dataSource)
            strongSelf.updateViewDataSource()
        }

    }

    func editPerconalCard() {
        let createPersonalCardViewController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
        if let cardDetails = cardDetails {
            let presenter = CreatePersonalCardPresenter(detailsModel: CreatePersonalCard.DetailsModel(apiModel: cardDetails))
            createPersonalCardViewController.presenter = presenter
        } else {
            let presenter = CreatePersonalCardPresenter()
            createPersonalCardViewController.presenter = presenter
        }
        view?.push(controller: createPersonalCardViewController, animated: true)
    }

    func share() {
        let socialMetaTags = DynamicLinkSocialMetaTagParameters()
        socialMetaTags.imageURL = URL.init(string: cardDetails?.avatar?.sourceUrl ?? "")
        socialMetaTags.title = "\(cardDetails?.cardCreator?.firstName ?? "") \(cardDetails?.cardCreator?.lastName ?? "")"
        socialMetaTags.descriptionText = cardDetails?.description
        view?.showShareSheet(path: .personalCard, parameters: [.id: "\(personalCardId)"], dynamicLinkSocialMetaTagParameters: socialMetaTags, successCompletion: { [weak self] in
            guard let self = self else { return }
            APIClient.default.incrementStatisticCount(cardID: self.personalCardId) { _ in }
        })
    }
    

}

// MARK: - PersonalCardDetailsPresenter

private extension PersonalCardDetailsPresenter {

    func updateViewDataSource() {
        // User info section
        let userInfoSection = Section<PersonalCardDetails.Cell>(items: [
            .userInfo(model: cardDetails),
        ])

        // album preview section
        var albumPreviewSection = Section<PersonalCardDetails.Cell>(items: [
            .actionTitle(model: ActionTitleModel(title: "PersonalCard.section.ownerArticles.title".localized, counter: self.albumPreviewSection?.items.count))
        ])
        if !(self.albumPreviewSection?.items.isEmpty ?? true) {
            albumPreviewSection.items.append(.postPreview(model: self.albumPreviewSection))
        }

        // get in touch section
        var getInTouchSection = Section<PersonalCardDetails.Cell>(items: [
            .sectionHeader,
            .title(text: "PersonalCard.section.contacts.title".localized)
        ])

        let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
        if !listListItems.isEmpty {
            getInTouchSection.items.append(.socialList)
        }
        getInTouchSection.items.append(.getInTouch)

        dataSource?.sections = [userInfoSection, albumPreviewSection, getInTouchSection]

        isUserOwner ? view?.setupEditView() : view?.setupEmptyBottomView()
        view?.reload()
    }


}

// MARK: - SocialsListTableViewCellDataSource

extension PersonalCardDetailsPresenter: SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
            return listListItems
        }
        set {}
    }


}

// MARK: - SocialsListTableViewCellDelegate

extension PersonalCardDetailsPresenter: SocialsListTableViewCellDelegate {

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .view(let model):
            if let url = model.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                view?.errorAlert(message: "Error.Social.unreadableFormat".localized)
            }
        default:
            break
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {
    }


}

// MARK: - GetInTouchTableViewCellDelegate

extension PersonalCardDetailsPresenter: GetInTouchTableViewCellDelegate {

    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell) {
        view?.makeCall(to: cardDetails?.contactTelephone?.number)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: cardDetails?.contactEmail?.address ?? "")
    }


}

// MARK: - PersonalCardUserInfoTableViewCellDelegate

extension PersonalCardDetailsPresenter: PersonalCardUserInfoTableViewCellDelegate {

    func onSaveCard(cell: PersonalCardUserInfoTableViewCell) {
        let state = cardDetails?.isSaved ?? false

        switch state {
        case false:
            view?.startLoading()
            APIClient.default.addCardToFavourites(id: personalCardId) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success:
                    cell.saveButton.isSelected = true
                    self?.cardDetails?.isSaved = true
                    NotificationCenter.default.post(name: .cardSaved, object: nil, userInfo: [Notification.Key.cardID: strongSelf.personalCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                    self?.view?.stopLoading(success: true, succesText: "SavedContent.cardSaved.message".localized, failureText: nil, completion: nil)
                case .failure:
                    self?.view?.stopLoading(success: false)
                }
            }

        case true:
            view?.startLoading()
            APIClient.default.deleteCardFromFavourites(id: personalCardId) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success:
                    cell.saveButton.isSelected = false
                    self?.cardDetails?.isSaved = false
                    NotificationCenter.default.post(name: .cardUnsaved, object: nil, userInfo: [Notification.Key.cardID: strongSelf.personalCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                    self?.view?.stopLoading(success: true, succesText: "SavedContent.cardUnsaved.message".localized, failureText: nil, completion: nil)
                case .failure:
                    self?.view?.stopLoading(success: false)
                }
            }
        }

    }


}

// MARK: - AlbumPreviewItemsViewDelegate, AlbumPreviewItemsViewDataSource

extension PersonalCardDetailsPresenter: AlbumPreviewItemsViewDelegate, AlbumPreviewItemsViewDataSource {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, didSelectedAt indexPath: IndexPath, dataSourceID: String?) {
        guard let id = dataSourceID, let dataSource = BusinessCardDetails.PostPreviewDataSourceID(rawValue: id) else {
            return
        }

        switch dataSource {
        case .albumPreviews:
            if let selectedItem = albumPreviewSection?.items[safe: indexPath.item] {
                switch selectedItem {
                case .add:
                    self.view?.goToCreatePost(cardID: personalCardId)
                case .view(let model):
                    let presenter = ArticleDetailsPresenter(albumID: model.albumID, articleID: model.articleID)
                    self.view?.goToArticleDetails(presenter: presenter)
                case .showMore:
                    break
                }
            }
        }
    }

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, dataSourceID: String?) -> [PostPreview.Item] {
        guard let id = dataSourceID, let dataSource = BusinessCardDetails.PostPreviewDataSourceID(rawValue: id) else {
            return []
        }

        switch dataSource {
        case .albumPreviews:
            return albumPreviewSection?.items ?? []
        }
    }


}
