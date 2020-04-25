//
//  BusinessCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CoreLocation

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

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.attachView(self)
        presenter?.onViewDidLoad()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - BusinessCardDetailsView

    func setupLayout() {
        self.navigationItem.title = "Бізнес візитка"
        self.tableView.delegate = self
    }

    func setupEditCardView() {
        tableView.tableFooterView = editCardView
    }

    func setupHideCardView() {
        tableView.tableFooterView = hideCardView
    }

    func set(dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload(section: BusinessCardDetails.SectionAccessoryIndex, animation: UITableView.RowAnimation) {
        let section = IndexSet(integer: section.rawValue)
        tableView.performBatchUpdates({
            tableView.reloadSections(section, with: animation)
        }) { (_) in

        }

    }

    func updateRows(insertion: [IndexPath], deletion: [IndexPath], insertionAnimation: UITableView.RowAnimation, deletionAnimation: UITableView.RowAnimation) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: deletion, with: insertionAnimation)
            tableView.insertRows(at: insertion, with: deletionAnimation)
        }) { (_) in

        }
    }

    func reload() {
        tableView.reloadData()
    }

    func openGoogleMaps() {
        let currentUserLocation = locationManager.location

        startLoading()
        presenter?.getRouteDestination(callback: { [unowned self] (destination) in
            self.stopLoading()

            guard let routeURL = APIConstants.Google.googleMapsRouteURL(saddr: currentUserLocation?.coordinate, daddr: destination, directionMode: .driving) else {
                self.errorAlert(message: "Не визначені адреси маршрутів")
                return
            }

            if UIApplication.shared.canOpenURL(routeURL) {
                UIApplication.shared.open(routeURL)
            } else {
                self.errorAlert(message: "Не вдається відкрити карти")
                Log.error("Can't use comgooglemaps://")
            }

        })

    }

    func openSettings(message: String?) {
        let alertController = UIAlertController (title: nil, message: message, preferredStyle: .alert)
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


}

// MARK: - UITableViewDelegate

extension BusinessCardDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue {
            return itemsBarView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue {
            return itemsBarView.frame.height
        }
        return 0
    }

}

// MARK: - MapDirectionTableViewCellDelegate

extension BusinessCardDetailsViewController: MapDirectionTableViewCellDelegate {

    func didOpenGoogleMaps(_ view: MapDirectionTableViewCell) {
        if locationManager.location == nil {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            openGoogleMaps()
        }
    }


}

// MARK: - LLocationManagerDelegate

extension BusinessCardDetailsViewController: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            Log.debug("Location status is OK.")
            openGoogleMaps()
            break
        case .restricted:
            Log.error("Location access was restricted.")
            fallthrough
        case .denied:
            Log.error("User denied access to location.")
            fallthrough
        case .notDetermined:
            Log.error("Location status not determined.")
            fallthrough
        @unknown default:
            break
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        Log.error(error)
        openSettings(message: "Для цьої дії потрібно дозволити додатку відстежити ваше місцеположення.")
    }


}


