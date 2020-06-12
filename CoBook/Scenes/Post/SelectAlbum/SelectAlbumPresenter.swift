//
//  SelectAlbumPresenter.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SelectAlbumView: AlertDisplayableView, LoadDisplayableView, NavigableView, SelectAlbumTableViewCellDelegate {
    func set(albums: TableDataSource<SelectAlbumCellsConfigurator>?)
    func goToCreateAlbum(presenter: CreateAlbumPresenter)
    func reload()
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
    private var albumsDataSource: TableDataSource<SelectAlbumCellsConfigurator>?

    // delegation object
    weak var delegate: SelectAlbumDelegate?

    // MARK: - Object Life Cycle

    init(cardID: Int, selectedAlbumID: Int?) {
        self.cardID = cardID
        self.selectedAlbumID = selectedAlbumID

        var photosDataSourceConfigurator = SelectAlbumCellsConfigurator()
        photosDataSourceConfigurator.selectAlbumCellConfigurator = TableCellConfigurator { [weak self] (cell, model: PostPreview.Item.Model, tableView, indexPath) -> SelectAlbumTableViewCell in
            cell.delegate = self?.view
            cell.isSelected = model.isSelected
            cell.albumTitleLabel.text = model.title
            cell.albumImageView.setImage(withPath: model.avatarPath)
            return cell
        }

        self.albumsDataSource = TableDataSource(configurator: photosDataSourceConfigurator)
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
        presenter.delegate = self
        view?.goToCreateAlbum(presenter: presenter)
    }
    

}

// MARK: - CreateAlbumDelegate

extension SelectAlbumPresenter: CreateAlbumDelegate {

    func albumEdited(with parameters: CreateAlbumModel) {
        guard let itemIndexToUpdate = albumsDataSource?.sections[safe: 0]?.items.firstIndex(where: { (model) -> Bool in
            model.albumID == parameters.albumID
        }) else {
            return
        }

        let updatedModel = PostPreview.Item.Model(albumID: parameters.albumID,
                                                  isSelected: parameters.albumID == selectedAlbumID ?? -1,
                                                  title: parameters.title,
                                                  avatarPath: parameters.avatarPath,
                                                  avatarID: parameters.avatarID)

        albumsDataSource?.sections[safe: 0]?.items[itemIndexToUpdate] = updatedModel
        self.view?.reload()

        // update if selected article creation form
        if parameters.albumID == selectedAlbumID ?? -1 {
            delegate?.selectedAlbum(updatedModel)
        }

    }


}
