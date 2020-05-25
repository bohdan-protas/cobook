//
//  ArticleDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol ArticleDetailsView: LoadDisplayableView, AlertDisplayableView, NavigableView {
    func reload()
    func set(dataSource: DataSource<ArticleDetailsCellConfigutator>?)
    func set(title: String?)
    func setPlaceholderView(_ visible: Bool)
    func goToEditArticle(presenter: CreateArticlePresenter)
}

class ArticleDetailsPresenter: BasePresenter {

    /// managed view
    weak var view: ArticleDetailsView?

    /// view datasource
    private var articleDetails: ArticleDetailsAPIModel?
    private var articles: [ArticlePreviewAPIModel]?

    private var dataSource: DataSource<ArticleDetailsCellConfigutator>?
    private var albumID: Int
    private var articleID: Int?

    var isOwner: Bool {
        return articleDetails?.userID == AppStorage.User.Profile?.userId
    }

    // MARK: Initialize

    /**
    initialize with card id, and then presenter fetch all albums by this card, and show first

    - parameters:
       - albumID: articles albumID
    */
    init(albumID: Int, articleID: Int?) {
        self.albumID = albumID
        self.articleID = articleID
        self.dataSource = DataSource(configurator: dataSourceConfigurator)
        self.dataSource?.sections = [
            Section<ArticleDetails.Cell>(accessoryIndex: ArticleDetails.SectionAccessory.details.rawValue, items: []),
            Section<ArticleDetails.Cell>(accessoryIndex: ArticleDetails.SectionAccessory.list.rawValue, items: [])
        ]
    }

    // MARK: - Base

    func attachView(_ view: ArticleDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public

    func setup() {
        view?.set(title: "Стаття")
        view?.set(dataSource: dataSource)
    }

    func refresh() {
        self.dataSource?.sections = [
            Section<ArticleDetails.Cell>(accessoryIndex: ArticleDetails.SectionAccessory.details.rawValue, items: []),
            Section<ArticleDetails.Cell>(accessoryIndex: ArticleDetails.SectionAccessory.list.rawValue, items: [])
        ]
        view?.reload()
    }

    func fetchDetails() {
        view?.startLoading()
        APIClient.default.getArticlesList(albumID: albumID) { [weak self] (result) in
            switch result {
            case .success(let articles):
                self?.articles = articles
                if let id = self?.articleID ?? articles?.first?.id {
                    self?.view?.setPlaceholderView(false)
                    self?.fetchArticleDetails(articleID: id)
                } else {
                    self?.view?.setPlaceholderView(true)
                    self?.view?.stopLoading()
                }
            case .failure(let error):
                self?.view?.stopLoading()
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func cellSelected(at indexPath: IndexPath) {
        guard let item = dataSource?.sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            Log.error("Error occured when selected account action type")
            return
        }

        switch item {
        case .articlePreview(let model):
            refresh()
            fetchArticleDetails(articleID: model.id)
        default:
            break
        }

    }


}

// MARK: - Privates

private extension ArticleDetailsPresenter {

    func updateViewDataSource() {
        // details
        dataSource?.sections[ArticleDetails.SectionAccessory.details.rawValue].items = [

            .header(model: ArticleDetails.HeaderModel(avatar: articleDetails?.cardInfo?.avatar?.sourceUrl,
                                                      firstName: "\(articleDetails?.cardInfo?.cardCreator?.firstName ?? "")",
                                                      lastName: "\(articleDetails?.cardInfo?.cardCreator?.lastName ?? "")",
                                                      date: articleDetails?.createdAt,
                                                      viewersCount: articleDetails?.viewsCount)),
            .photoCollage,
            .descriptionDetails(model: ArticleDetails.DescriptionModel(title: articleDetails?.title,
                                                                       desctiption: articleDetails?.body,
                                                                       albumAvatarImage: articleDetails?.album?.avatar?.sourceUrl,
                                                                       albumAvatarTitle: articleDetails?.album?.title)),
            .creator(model: CardPreviewModel(id: articleDetails?.userID ?? "",
                                             image: articleDetails?.cardInfo?.avatar?.sourceUrl,
                                             firstName: articleDetails?.cardInfo?.company?.name,
                                             lastName: nil,
                                             profession: articleDetails?.cardInfo?.practiceType?.title,
                                             telephone: articleDetails?.cardInfo?.telephone?.number))
        ]

        // articles list
        let items = articles?
            .compactMap { ArticlePreviewModel(id: $0.id, title: $0.title, image: $0.avatar?.sourceUrl) }
            .filter { $0.id != (self.articleDetails?.articleID ?? -1) } ?? []

        dataSource?.sections[ArticleDetails.SectionAccessory.list.rawValue].items = items.map { ArticleDetails.Cell.articlePreview(model: $0) }
        view?.reload()
    }

    func goToEdit() {
        let parameters = CreateArticleModel(articleID: articleDetails?.articleID,
                                            cardID: articleDetails?.cardInfo?.id ?? -1,
                                            title: articleDetails?.title,
                                            body: articleDetails?.body,
                                            album: AlbumPreview.Item.Model(id: articleDetails?.album?.id ?? -1,
                                                                           isSelected: true,
                                                                           title: articleDetails?.album?.title,
                                                                           avatarPath: articleDetails?.album?.avatar?.sourceUrl,
                                                                           avatarID: articleDetails?.album?.avatar?.id),
                                            photos: articleDetails?.photos ?? [])
        let presenter = CreateArticlePresenter(parameters: parameters)
        presenter.delegate = self
        view?.goToEditArticle(presenter: presenter)
    }

    func fetchArticleDetails(articleID: Int) {
        APIClient.default.getArticleDetails(articleID: articleID) { [weak self] (result) in
            self?.view?.stopLoading()
            switch result {
            case .success(let articleDetails):
                self?.articleDetails = articleDetails
                self?.updateViewDataSource()
            case .failure(let error):
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func saveArticle() {
        view?.startLoading()
        APIClient.default.addArticleToFavourites(id: articleDetails?.articleID ?? -1) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                self?.articleDetails?.isSaved = true
                self?.view?.stopLoading(success: true, succesText: "Article.Saved".localized, failureText: nil, completion: nil)
                if let id = strongSelf.articleDetails?.articleID {
                    NotificationCenter.default.post(name: .articleSaved, object: nil, userInfo: [Notification.Key.articleID: id, Notification.Key.controllerID: ArticleDetailsViewController.describing])
                }
            case .failure:
                self?.view?.stopLoading(success: false)
            }
        }
    }

    func unsaveArticle() {
        view?.startLoading()
        APIClient.default.addArticleToFavourites(id: articleDetails?.articleID ?? -1) { [weak self] (result) in
            switch result {
            case .success:
                self?.articleDetails?.isSaved = false
                self?.view?.stopLoading(success: true, succesText: "Article.Unsaved".localized, failureText: nil, completion: nil)
                if let id = self?.articleDetails?.articleID {
                    NotificationCenter.default.post(name: .articleUnsaved, object: nil, userInfo: [Notification.Key.articleID: id, Notification.Key.controllerID: ArticleDetailsViewController.describing])
                }
            case .failure:
                self?.view?.stopLoading(success: false)
            }
        }
    }



}

// MARK: - PhotoCollageTableViewCellDataSource

extension ArticleDetailsPresenter: PhotoCollageTableViewCellDataSource {

    func photoCollage(_ view: PhotoCollageTableViewCell) -> [String?] {
        return articleDetails?.photos?.compactMap { $0.sourceUrl } ?? []
    }


}

// MARK: - ArticleHeaderTableViewCellDelegate

extension ArticleDetailsPresenter: ArticleHeaderTableViewCellDelegate {

    func moreButtonAction(_ cell: ArticleHeaderTableViewCell) {
        var actions: [UIAlertAction] = []

        // save action
        if let isSaved = self.articleDetails?.isSaved  {
            actions.append(
                .init(title: isSaved ? "Unsave".localized : "Save".localized, style: .default, handler: { (_) in
                    switch isSaved {
                    case true: self.unsaveArticle()
                    case false: self.saveArticle()
                    }
                })
            )
        }

        // share action
        actions.append(
            .init(title: "Поширити", style: .default, handler: { (_) in
                Log.debug("Поширити")
            })
        )

        // edit action
        if isOwner {
            actions.append(
                .init(title: "Редагувати", style: .default, handler: { [weak self] (_) in
                    self?.goToEdit()
                })
            )

        }

        actions.append(.init(title: "Відмінити", style: .cancel, handler: nil))
        view?.actionSheetAlert(title: nil, message: nil, actions: actions)
    }


}

// MARK: - CreateArticlePresenterDelegate

extension ArticleDetailsPresenter: CreateArticlePresenterDelegate {

    func didFinishUpdating(_ presenter: CreateArticlePresenter) {
        if let id = articleDetails?.articleID {
            view?.stopLoading()
            fetchArticleDetails(articleID: id)
        }

    }


}
