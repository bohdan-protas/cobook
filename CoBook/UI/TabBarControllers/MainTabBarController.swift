//
//  MainTabBarController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
import Firebase

class MainTabBarController: UITabBarController {

    lazy var allCardsController: UIViewController = {
        let allCardsController: CardsOverviewNavigationController = UIStoryboard.allCards.initiateViewControllerFromType()
        allCardsController.tabBarItem = UITabBarItem(title: "Tabbar.allCards.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_allcards_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_allcards_active"))
        return allCardsController
    }()
    
    lazy var savedContentController: UIViewController = {
        let savedContentController: SavedContentNavigationController = UIStoryboard.saved.initiateViewControllerFromType()
        savedContentController.tabBarItem = UITabBarItem(title: "Tabbar.saved.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_saved_unactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_saved_active"))
        return savedContentController
    }()

    lazy var notificationsController: UIViewController = {
        let notificationsListController: NotificationsListViewController = UIStoryboard.notifications.initiateViewControllerFromType()
        let notificationsNavigation = CustomNavigationController(rootViewController: notificationsListController)
        notificationsNavigation.tabBarItem = UITabBarItem(title: "Tabbar.notifications.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_notifications_unactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_notifications_active"))
        return notificationsNavigation
    }()
    
    lazy var accountController: UIViewController = {
        let accountController: AccountNavigationController = UIStoryboard.account.initiateViewControllerFromType()
        accountController.tabBarItem = UITabBarItem(title: "Tabbar.account.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_account_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_account_active"))
        return accountController
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [allCardsController, savedContentController, notificationsController, accountController]
        self.selectedViewController = allCardsController

        // If pending dynamic link exists - its time to show recognized controller
        if let pendingDynamicLink = AppStorage.State.pendingDynamicLink {
            handleDynamicLink(pendingDynamicLink)
        }
        
        // If device token failed to refresh in app delegate(due the authorization reson), we will refresh again in after login
        if AppStorage.State.isNeedToUpdateDeviceToken {
            AppStorage.State.isNeedToUpdateDeviceToken = false
            updateFCMToken()
        }
        
    }

    // MARK: - Dynamic link handling

    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        // clear the current pending state
        AppStorage.State.pendingDynamicLink = nil

        // regognize contoller to push from dynamic link
        if let recognizedController = DynamicLinkCoordinatorService().recognizeControllerFrom(dynamicLink: dynamicLink) {
             pushDynamicLink(recognizedController: recognizedController)
        } else {
            Log.error("Cannot recognize contoller from dynamic link: \(dynamicLink)")
        }
    }

    func handleDynamicLink(_ dynamicLink: DynamicLinkContainer) {
        // clear the current pending state url
        AppStorage.State.pendingDynamicLink = nil

        // regognize contoller to push from dynamic link
        if let recognizedController = DynamicLinkCoordinatorService().recognizeControllerFrom(dynamicLink: dynamicLink) {
            pushDynamicLink(recognizedController: recognizedController)
        } else {
            Log.error("Cannot recognize contoller from dynamic link: \(dynamicLink)")
        }
    }
    
    // MARK: - Notifications
    
    func updateFCMToken() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                let token = result.token
                APIClient.default.updateDeviceToken(fcmToken: token) { (result) in
                    switch result {
                    case .success:
                        Log.info("Success updated token in application server: \(token)")
                    case .failure(let erorr):
                        Log.error(erorr.localizedDescription)
                    }
                }
            }
        }
    }
    
    func handleNofitication() {
        self.selectedViewController = notificationsController
    }
    

}

// MARK: - Privates

private extension MainTabBarController {

    func pushDynamicLink(recognizedController: UIViewController) {
        let currentNavigationController = selectedViewController as? UINavigationController
        let currentControllersStack = currentNavigationController?.viewControllers
        if let rootController = currentControllersStack?.first {
            currentNavigationController?.setViewControllers([rootController, recognizedController], animated: true)
        } else {
            Log.error("Cannot define current contollers stack")
        }
    }

}
