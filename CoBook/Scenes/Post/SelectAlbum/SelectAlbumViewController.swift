//
//  SelectAlbumViewController.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SelectAlbumViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: SelectAlbumPresenter?

    // MARK: - Actions

    @IBAction func addAlbumTapped(_ sender: Any) {
        presenter?.createAlbumSelected()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Вибрати альбом"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.attachView(self)
        presenter?.setup()
    }


}

// MARK: - SelectAlbumView

extension SelectAlbumViewController: SelectAlbumView {

    func set(albums: DataSource<SelectAlbumCellsConfigurator>?) {
        albums?.connect(to: tableView)
        tableView.reloadData()
    }

    func goToCreateAlbum(presenter: CreateAlbumPresenter) {
        let controller = UIStoryboard.Post.Controllers.createAlbum
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
