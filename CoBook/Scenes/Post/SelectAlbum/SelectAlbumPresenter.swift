//
//  SelectAlbumPresenter.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SelectAlbumView: AlertDisplayableView, LoadDisplayableView, NavigableView, SelectAlbumTableViewCellDelegate {
    func set(albums: DataSource<SelectAlbumCellsConfigurator>?)
    func goToCreateAlbum(presenter: CreateAlbumPresenter)
}

protocol SelectAlbumDelegate: class {
    func selectedAlbum(_ model: PostPreview.Item.Model?)
}

class SelectAlbumPresenter: BasePresenter {

    // managed view
    weak var view: SelectAlbumView?

    // View data source
    private var cardID: Int
    private var selectedAlbumID: Int?
    private var albumsDataSource: DataSource<SelectAlbumCellsConfigurator>?

    // delegation object
    weak var delegate: SelectAlbumDelegate?

    // MARK: - Object Life Cycle

    init(cardID: Int, selectedAlbumID: Int?) {
        self.cardID = cardID
        self.selectedAlbumID = selectedAlbumID

        var photosDataSourceConfigurator = SelectAlbumCellsConfigurator()
        photosDataSourceConfigurator.selectAlbumCellConfigurator = CellConfigurator { [weak self] (cell, model: PostPreview.Item.Model, tableView, indexPath) -> SelectAlbumTableViewCell in
            cell.delegate = self?.view
            cell.editButton.isHidden = model.isSelected
            cell.isSelected = model.isSelected
            cell.albumTitleLabel.text = model.title
            cell.albumImageView.setImage(withPath: model.avatarPath)
            return cell
        }

        self.albumsDataSource = DataSource(configurator: photosDataSourceConfigurator)
    }

    // MARK: - BasePresenter

    func attachView(_ view: SelectAlbumView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    // MARK: - Public

    func createAlbumSelected() {
        let presenter = CreateAlbumPresenter(cardID: cardID)
        view?.goToCreateAlbum(presenter: presenter)
    }

    func setup() {
        view?.startLoading()
        APIClient.default.getAlbumsList(cardID: cardID) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let apiItems):
                let items: [PostPreview.Item.Model] = apiItems?.compactMap { PostPreview.Item.Model(albumID: $0.id,
                                                                                                      isSelected: $0.id == strongSelf.selectedAlbumID ?? -1,
                                                                                                      title: $0.title,
                                                                                                      avatarPath: $0.avatar?.sourceUrl,
                                                                                                      avatarID: $0.avatar?.id) } ?? []
                strongSelf.albumsDataSource?.sections = [Section(items: items)]
                strongSelf.view?.set(albums: strongSelf.albumsDataSource)
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func selectedAlbumAt(indexPath: IndexPath) {
        let model = albumsDataSource?.sections[indexPath.section].items[indexPath.item]
        delegate?.selectedAlbum(model)
        view?.popController()
    }

    func editAlbumAt(indexPath: IndexPath) {
        let model = albumsDataSource?.sections[indexPath.section].items[indexPath.item]
        let parameters = CreateAlbumModel(cardID: cardID, albumID: model?.albumID, avatarID: model?.avatarID, avatarPath: model?.avatarPath, title: model?.title)
        let presenter = CreateAlbumPresenter(parameters: parameters)
        view?.goToCreateAlbum(presenter: presenter)
    }
    

}
