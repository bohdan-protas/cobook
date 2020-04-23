//
//  BusinessCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
    static let hideCardViewHeight: CGFloat = 102
    static let editCardViewHeight: CGFloat = 84
}

class BusinessCardDetailsViewController: BaseViewController, BusinessCardDetailsView {

    @IBOutlet var tableView: UITableView!

    var presenter: BusinessCardDetailsPresenter?

    /// hideCardView
    private lazy var hideCardView: HideCardView = {
        let view = HideCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.hideCardViewHeight)))
        view.onHideTapped = { [weak self] in
        }
        return view
    }()

    /// editCardView
    private lazy var editCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.onEditTapped = { [weak self] in
            self?.presenter?.editBusinessCard()
        }
        return view
    }()

    /// itemsBarView
    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: self.presenter?.barItems ?? [])
        view.delegate = self.presenter
        return view
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    deinit {
        presenter?.detachView()
    }

    func setupLayout() {
        navigationItem.title = "Бізнес візитка"
        tableView.delegate = self
    }

    // MARK: - BusinessCardDetailsView

    func setupEditCardView() {
        tableView.tableFooterView = editCardView
    }

    func setupHideCardView() {
        tableView.tableFooterView = hideCardView
    }

    func set(dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload(section: BusinessCardDetails.SectionAccessoryIndex) {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
        tableView.endUpdates()
    }

    func reload() {
        tableView.reloadData()
    }

    func sendEmail(to address: String) {
        
    }

    func openSettings() {
        let alertController = UIAlertController (title: nil, message: "Перейти в налаштування?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Налаштування", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    Log.debug("Settings opened")
                })
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func goToCreateService() {
        let controller: CreateServiceViewController = self.storyboard!.initiateViewControllerFromType()
        push(controller: controller, animated: true)
    }


}

// MARK: - UITableViewDelegate

extension BusinessCardDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return itemsBarView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return itemsBarView.frame.height
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.selectedRow(at: indexPath)
    }

}

// MARK: - MapDirectionTableViewCellDelegate

extension BusinessCardDetailsViewController: MapDirectionTableViewCellDelegate {

    func didOpenGoogleMaps(_ view: MapDirectionTableViewCell) {

        if let googleMapsUrl = URL.init(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(googleMapsUrl) {

            UIApplication.shared.open(googleMapsUrl)

        } else {
            errorAlert(message: "Не вдається відкрити карти")
            Log.error("Can't use comgooglemaps://")
        }

    }


}
