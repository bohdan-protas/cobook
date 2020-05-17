//
//  SavedContentViewController.swift
//  CoBook
//
//  Created by protas on 5/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SavedContentViewController: BaseViewController {

    /// main tableView
    @IBOutlet var tableView: UITableView!

    /// itemsBarView
    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: [])
        view.delegate = self
        return view
    }()

    var presenter: SavedContentPresenter = SavedContentPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()

        presenter.attachView(self)
        presenter.setup()
    }

    deinit {
        presenter.detachView()
    }


}

// MARK: - Privates

private extension SavedContentViewController {

    func setupLayout() {
        self.tableView.delegate = self
        self.navigationItem.title = "Saved".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }


}

// MARK: - SavedContentView

extension SavedContentViewController: SavedContentView {

    func createFolder() {
        newFolderAlert(folderName: nil, completion: { [unowned self] (folderName) in
            self.presenter.createFolder(title: folderName) { (barItem) in
                self.itemsBarView.append(barItem: barItem)
            }
        })
    }

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: DataSource<SavedContentCellConfigurator>?) {
        dataSource?.connect(to: self.tableView)
    }

    func set(barItems: [BarItem]) {
        itemsBarView.dataSource = barItems
        itemsBarView.refresh()
    }

    func reload(section: SavedContent.SectionAccessoryIndex) {
        tableView.beginUpdates()
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
        tableView.endUpdates()
    }


}

// MARK: - UITableViewDelegate

extension SavedContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SavedContent.SectionAccessoryIndex.card.rawValue {
            return itemsBarView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SavedContent.SectionAccessoryIndex.card.rawValue {
            return itemsBarView.frame.height
        }
        return 0
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension SavedContentViewController: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        presenter.selectedBarItemAt(index: index)
    }

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didLongTappedItemAt index: Int) {
        let actions: [UIAlertAction] = [
            .init(title: "Видалити", style: .destructive, handler: { [unowned self] (_) in
                self.presenter.deleteFolder(at: index) { [unowned self] in
                    self.itemsBarView.delete(at: index)
                }
            }),

            .init(title: "Змінити", style: .default, handler: { [unowned self] (_) in
                let title = self.itemsBarView.dataSource[safe: index]?.title
                self.newFolderAlert(folderName: title, completion: { [unowned self] (folderName) in
                    self.presenter.updateFolder(at: index, withNewTitle: folderName) { [unowned self] (updatedBarItem) in
                        self.itemsBarView.update(at: index, with: updatedBarItem)
                    }
                })
            }),

            .init(title: "Відмінити", style: .cancel, handler: { (_) in
                Log.debug("Cancel")
            })
        ]
        if presenter.isEditableBarItemAt(index: index) {
            actionSheetAlert(title: nil, message: nil, actions: actions)
        }
    }


}
