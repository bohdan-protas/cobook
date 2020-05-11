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
    private var cardID: Int

    var isOwner: Bool {
        return articleDetails?.userID == AppStorage.User.Profile?.userId
    }

    // MARK: Initialize

    /**
    initialize with card id, and then presenter fetch all albums by this card, and show first

    - parameters:
       - albumID: articles albumID
    */
    init(albumID: Int, cardID: Int) {
        self.albumID = albumID
        self.cardID = cardID
        
        var configurator = ArticleDetailsCellConfigutator()

        configurator.articlePreviewConfigurator = CellConfigurator { (cell, model: ArticlePreviewModel, tableView, indexPath) -> ArticlePreviewTableViewCell in
            cell.articleTitle.text = model.title
            cell.articleImageView.setImage(withPath: model.image)
            return cell
        }

        configurator.photoCollageConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> PhotoCollageTableViewCell in
            cell.dataSource = self
            cell.prepareLayout()
            return cell
        }

        configurator.headerConfigurator = CellConfigurator { (cell, model: ArticleDetails.HeaderModel, tableView, indexPath) -> ArticleHeaderTableViewCell in
            cell.delegate = self

            let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
            let textPlaceholderImage = nameAbbr.image(size: cell.avatarImageView.frame.size)

            cell.avatarImageView.setImage(withPath: model.avatar, placeholderImage: textPlaceholderImage)
            cell.nameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
            cell.dateLabel.text = model.date
            cell.viewsCountLabel.text = model.viewersCount
            return cell
        }

        configurator.descriptionCellConfigurator = CellConfigurator { (cell, model: ArticleDetails.DescriptionModel, tableView, indexPath) -> ArticleDescriptionTableViewCell in
            cell.albumNameLabel.text = model.albumAvatarTitle
            cell.albumImageView.setImage(withPath: model.albumAvatarImage)
            cell.titleLabel.text = model.title
            cell.descriptionTextView.text = model.desctiption
            return cell
        }

        configurator.creatorCellConfigurator = CellConfigurator { (cell, model: CardPreviewModel, tableView, indexPath) -> CardPreviewTableViewCell in
            let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
            let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)

            cell.titleImageView.setImage(withPath: model.image, placeholderImage: textPlaceholderImage)
            cell.proffesionLabel.text = model.profession
            cell.telephoneNumberLabel.text = model.telephone
            cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"

            cell.selectionStyle = .none
            cell.accessoryView = nil
            return cell
        }

        self.dataSource = DataSource(configurator: configurator)
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
                guard let id = articles?.first?.id else {
                    self?.view?.setPlaceholderView(true)
                    self?.view?.stopLoading()
                    return
                }
                self?.view?.setPlaceholderView(false)
                self?.fetchArticleDetails(articleID: id)
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

    func fetchArticleDetails(articleID: Int) {
        APIClient.default.getArticleDetails(articleID: articleID) { [weak self] (result) in
            switch result {
            case .success(let articleDetails):
                self?.view?.stopLoading()
                self?.articleDetails = articleDetails
                self?.updateViewDataSource()
            case .failure(let error):
                self?.view?.stopLoading()
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateViewDataSource() {

        // details
        dataSource?.sections[ArticleDetails.SectionAccessory.details.rawValue].items = [

            .header(model: ArticleDetails.HeaderModel(avatar: articleDetails?.cardInfo?.avatar?.sourceUrl,
                                                      firstName: "\(articleDetails?.cardInfo?.cardCreator?.firstName ?? "")",
                                                      lastName: "\(articleDetails?.cardInfo?.cardCreator?.lastName ?? "")",
                                                      date: "",
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
                                            cardID: cardID,
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
        var actions: [UIAlertAction] = [

            .init(title: "Зберегти", style: .default, handler: { (_) in
                Log.debug("Зберегти")
            }),

            .init(title: "Поширити", style: .default, handler: { (_) in
                Log.debug("Поширити")
            })
        ]

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
