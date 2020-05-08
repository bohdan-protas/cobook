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
        self.tableView.delegate = self
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

    func editAction(_ cell: SelectAlbumTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter?.editAlbumAt(indexPath: indexPath)
        }
    }


    func set(albums: DataSource<SelectAlbumCellsConfigurator>?) {
        albums?.connect(to: tableView)
        tableView.reloadData()
    }

    func goToCreateAlbum(presenter: CreateAlbumPresenter) {
        let controller: CreateAlbumViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }


}

// MARK: - UITableViewDelegate

extension SelectAlbumViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectedAlbumAt(indexPath: indexPath)
    }

}
