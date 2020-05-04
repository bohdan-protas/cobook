//
//  SelectAlbumPresenter.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SelectAlbumView: AlertDisplayableView, LoadDisplayableView {
    func goToCreateAlbum(presenter: CreateAlbumPresenter)
    func set(albums: DataSource<SelectAlbumCellsConfigurator>?)
}

class SelectAlbumPresenter: BasePresenter {

    // managed view
    weak var view: SelectAlbumView?

    // View data source
    private var cardID: Int
    private var albumsDataSource: DataSource<SelectAlbumCellsConfigurator>?

    // MARK: - Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID

        var photosDataSourceConfigurator = SelectAlbumCellsConfigurator()
        photosDataSourceConfigurator.selectAlbumCellConfigurator = CellConfigurator { (cell, model: AlbumPreviewModel, tableView, indexPath) -> SelectAlbumTableViewCell in
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
                let items: [AlbumPreviewModel] = apiItems?.compactMap { AlbumPreviewModel(id: $0.id, isSelected: false, title: $0.title, avatarPath: $0.avatar?.sourceUrl) } ?? []
                strongSelf.albumsDataSource?.sections = [Section(items: items)]
                strongSelf.view?.set(albums: strongSelf.albumsDataSource)
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }

    }

}
