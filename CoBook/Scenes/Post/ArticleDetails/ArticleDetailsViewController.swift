//
//  ArticleDetailsViewController.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: ArticleDetailsPresenter?

    private lazy var placeholderView: UIView = {
        let placeholderView = DeniedAccessToLocationPlaceholderView(frame: tableView.bounds)
        placeholderView.titleLabel.text = "Article.placeholder.emptyAlbumItems".localized
        placeholderView.actionButton.setTitle("Article.placeholder.back".localized, for: .normal)
        placeholderView.onOpenSettingsHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return placeholderView
    }()

    // MARK: - Actions

    @objc func shareTapped() {
        presenter?.share()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.setup()
        presenter?.fetchDetails()
    }

    deinit {
        presenter?.detachView()
    }


}

// MARK: - Privates

extension ArticleDetailsViewController {

    func setupLayout() {
        tableView.delegate = self
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_share"), style: .plain, target: self, action: #selector(shareTapped))
    }

}

// MARK: - ArticleDetailsView

extension ArticleDetailsViewController: ArticleDetailsView {

    func openPhotoGallery(photos: [String], activedPhotoIndex: Int) {
        let galleryController = PhotoGalleryViewController(photos: photos, selectedPhotoIndex: activedPhotoIndex)
        let navController = CustomNavigationController(rootViewController: galleryController)
        present(navController, animated: true, completion: nil)
    }

    func setPlaceholderView(_ visible: Bool) {
        if visible {
            tableView.backgroundView = placeholderView
        } else {
            tableView.backgroundView = nil
        }
    }

    func goToEditArticle(presenter: CreateArticlePresenter) {
        let controller: CreateArticleViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func set(title: String?) {
        self.navigationItem.title = title
    }

    func set(dataSource: TableDataSource<ArticleDetailsCellConfigutator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload() {
        tableView.reloadData()
    }


}

// MARK: - UITableViewDelegate

extension ArticleDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.cellSelected(at: indexPath)
    }


}


