//
//  ArticleDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol ArticleDetailsView: LoadDisplayableView, AlertDisplayableView {
    func reload()
    func set(dataSource: DataSource<ArticleDetailsCellConfigutator>?)
    func set(title: String?)
}

class ArticleDetailsPresenter: BasePresenter {

    /// managed view
    weak var view: ArticleDetailsView?

    /// view datasource
    private var articleDetails: ArticleDetailsAPIModel?
    private var articles: [ArticlePreviewAPIModel]?

    private var dataSource: DataSource<ArticleDetailsCellConfigutator>?
    private var albumID: Int

    // MARK: Initialize

    /**
    initialize with card id, and then presenter fetch all albums by this card, and show first

    - parameters:
       - albumID: articles albumID
    */
    init(albumID: Int) {
        self.albumID = albumID
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
            let nameAbbr = "\(model.name?.first?.uppercased() ?? "")"
            let textPlaceholderImage = nameAbbr.image(size: cell.avatarImageView.frame.size)

            cell.avatarImageView.image = textPlaceholderImage
            cell.nameLabel.text = model.name
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
        view?.set(title: "Пост")
        view?.set(dataSource: dataSource)
    }

    func fetchDetails() {
        view?.startLoading()
        APIClient.default.getArticlesList(albumID: albumID) { [weak self] (result) in
            self?.view?.stopLoading()
            switch result {
            case .success(let articles):
                self?.articles = articles
                guard let id = articles?.first?.id else { return }
                APIClient.default.getArticleDetails(articleID: id) { [weak self] (result) in
                    switch result {
                    case .success(let articleDetails):
                        self?.articleDetails = articleDetails
                        self?.updateViewDataSource()
                    case .failure(let error):
                        self?.view?.errorAlert(message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Privates

private extension ArticleDetailsPresenter {

    func updateViewDataSource() {

        // details
        dataSource?.sections[ArticleDetails.SectionAccessory.details.rawValue].items = [

            .header(model: ArticleDetails.HeaderModel(name: "Name Name",
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
        dataSource?.sections[ArticleDetails.SectionAccessory.list.rawValue].items.removeAll()
        let items = articles?.compactMap { ArticlePreviewModel(id: $0.id, title: $0.title, image: $0.avatar?.sourceUrl) } ?? []
        dataSource?.sections[ArticleDetails.SectionAccessory.list.rawValue].items = items.map { ArticleDetails.Cell.articlePreview(model: $0) }

        view?.reload()
    }
    

}

// MARK: - PhotoCollageTableViewCellDataSource

extension ArticleDetailsPresenter: PhotoCollageTableViewCellDataSource {

    func photoCollage(_ view: PhotoCollageTableViewCell) -> [String?] {
        return articleDetails?.photos?.compactMap { $0.sourceUrl } ?? []
    }


}
