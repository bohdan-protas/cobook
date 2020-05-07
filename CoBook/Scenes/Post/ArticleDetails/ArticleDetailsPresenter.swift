//
//  ArticleDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol ArticleDetailsView: class {
    
}

class ArticleDetailsPresenter: BasePresenter {

    /// managed view
    weak var view: ArticleDetailsView?

    /// view datasource
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
    }

    // MARK: - Base

    func attachView(_ view: ArticleDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public

    func fetchDetails() {
        APIClient.default.getArticlesList(albumID: albumID)
            .map({ $0.first!.id })
            .andThen(APIClient.default.getArticleDetails)
            .execute(onSuccess: { (articleDetailsApiModel) in
                Log.debug(articleDetailsApiModel)
            }) { (error) in
                Log.debug(error)
        }
    }

}

// MARK: - Privates

private extension CreateArticlePresenter {



}
