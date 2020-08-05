//
//  BusinessCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CoreLocation
import PortmoneSDKEcom

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
    static let hideCardViewHeight: CGFloat = 102
    static let editCardViewHeight: CGFloat = 84
}

class BusinessCardDetailsViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: BusinessCardDetailsPresenter?

    var cachedCellHeights = [IndexPath: CGFloat]()
    let paymentService = PaymentService()
    var pendingPaymentStatus: (bill: Bill?, error: Error?)?
    
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

        presenter?.attachView(self)
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - Actions

    @objc func shareTapped() {
        presenter?.share()
    }

    // MARK: - BusinessCardDetailsView

    func setupLayout() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "BusinessCard.title".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_share"), style: .plain, target: self, action: #selector(shareTapped))
        self.tableView.delegate = self
    }

    
}
 
// MARK: - BusinessCardDetailsView

extension BusinessCardDetailsViewController: BusinessCardDetailsView {
    
    func onExpandTapped(_ cell: ExpandableDescriptionTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter?.expandDescription(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func businessCardPayment(cardID: Int) {
        paymentService.businessCardPayment(cardID: "\(cardID)", presentingView: self, loadProgressView: self, delegate: self)
    }
    
    func setupEditCardView() {
        tableView.tableFooterView = editCardView
    }

    func setupHideCardView() {
        tableView.tableFooterView = hideCardView
    }

    func set(dataSource: TableDataSource<BusinessCardDetailsDataSourceConfigurator>?) {
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
        startLoading()
        presenter?.getRouteDestination(callback: { [unowned self] (destination) in
            self.stopLoading()

            guard let routeURL = Constants.Google.googleMapsRouteURL(daddr: destination, directionMode: .driving) else {
                self.errorAlert(message: "Error.Map.notDefinedRoute".localized)
                return
            }

            if UIApplication.shared.canOpenURL(routeURL) {
                UIApplication.shared.open(routeURL)
            } else {
                self.errorAlert(message: "Error.Map.cantOpen.message".localized)
                Log.error("Can't use comgooglemaps://")
            }

        })

    }

    // MARK: - Navigation

    func goToCreateService(presenter: CreateServicePresenter?) {
        let controller: CreateServiceViewController = self.storyboard!.initiateViewControllerFromType()
        controller.presenter = presenter
        push(controller: controller, animated: true)
    }

    func goToServiceDetails(presenter: ServiceDetailsPresenter?) {
        let controller: ServiceDetailsViewController = self.storyboard!.initiateViewControllerFromType()
        controller.presenter = presenter
        push(controller: controller, animated: true)
    }

    func goToCreateProduct(presenter: CreateProductPresenter?) {
        let controller: CreateProductViewController = self.storyboard!.initiateViewControllerFromType()
        controller.presenter = presenter
        push(controller: controller, animated: true)
    }

    func goToProductDetails(presenter: ProductDetailsPresenter?) {
        let controller: ProductDetailsViewController = self.storyboard!.initiateViewControllerFromType()
        controller.presenter = presenter
        push(controller: controller, animated: true)
    }

    func goToCreatePost(cardID: Int) {
        let controller: CreateArticleViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = CreateArticlePresenter(cardID: cardID)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func goToArticleDetails(presenter: ArticleDetailsPresenter) {
        let controller: ArticleDetailsViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToCreateFeedback(presenter: AddFeedbackPresenter) {
        let controller: AddFeedbackViewController = UIStoryboard.account.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter) {
        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
        personalCardDetailsViewController.presenter = presenter
        let navigationController = CustomNavigationController(rootViewController: personalCardDetailsViewController)
        self.presentPanModal(navigationController)
    }
    
    func showPaymentCard(presenter: PaymentPresenter, params: PaymentParams) {
         presenter.presentPaymentByCard(on: self, params: params, showReceiptScreen: true)
    }
    
    func openPhotoGallery(photos: [String], activedPhotoIndex: Int) {
        let galleryController = PhotoGalleryViewController(photos: photos, selectedPhotoIndex: activedPhotoIndex)
        let navController = CustomNavigationController(rootViewController: galleryController)
        present(navController, animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.selectedRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cachedCellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedCellHeights[indexPath] ?? UITableView.automaticDimension
    }

}

// MARK: - MapDirectionTableViewCellDelegate

extension BusinessCardDetailsViewController: MapDirectionTableViewCellDelegate {

    func didOpenGoogleMaps(_ view: MapDirectionTableViewCell) {
        openGoogleMaps()
    }


}

// MARK: - BusinessCardHeaderInfoTableViewCellDelegate

extension BusinessCardDetailsViewController: BusinessCardHeaderInfoTableViewCellDelegate {
    
    func onSaveCard(cell: BusinessCardHeaderInfoTableViewCell) {
        presenter?.save { (saved) in
            cell.saveCardButton.isSelected = saved
        }
    }
        
    
}

// MARK: - PaymentPresenterDelegate

extension BusinessCardDetailsViewController: PaymentPresenterDelegate {
    
    func didFinishPayment(bill: Bill?, error: Error?) {
        self.pendingPaymentStatus = (bill, error)
    }
    
    func dismissedSDK() {
        if let error = pendingPaymentStatus?.error {
            self.errorAlert(message: error.localizedDescription)
        }
        
        if let bill = pendingPaymentStatus?.bill {
            Log.debug(bill)
            
            self.infoAlert(title: "Payment.success.title".localized, message: "Payment.success.description".localized)
            Log.Firebase.businessCardPurchase(billID: bill.billId, value: "\(bill.billAmount)")
        }
        self.pendingPaymentStatus = nil
        self.presenter?.onViewWillAppear()
    }
    
    
}
