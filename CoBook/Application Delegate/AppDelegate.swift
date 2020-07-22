//
//  AppDelegate.swift
//  CoBook
//
//  Created by protas on 2/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseMessaging
import FirebaseDynamicLinks
import Nuke
import NukeAlamofirePlugin

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        defer {
            window?.makeKeyAndVisible()
        }
        
        /// Clear saved data in keychain if user reinstalled app
        if AppStorage.State.isFirstAppLaunch {
            AppStorage.deleteAllData()
            AppStorage.State.isFirstAppLaunch = false
        }
        
        /// Setup  appearence
        setupAppearence()
        setupScreenToOpen(on: window)
        
        //
        setupDepencencies(for: application)
        registerForPushNotifications(application: application)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.User.isUserInitiatedRegistration && !AppStorage.User.isUserCompletedRegistration {
            AppStorage.Auth.deleteAllData()
            AppStorage.User.Profile = nil
            AppStorage.User.isUserInitiatedRegistration = false
        }
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let isLinkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { [weak self] (dynamiclink, error) in
                guard error == nil else {
                    Log.error(error!.localizedDescription)
                    return
                }
                if let dynamiclink = dynamiclink {
                    self?.handleIncomingDynamicLink(dynamiclink)
                }
            }
            if isLinkHandled {
                return true
            } else {
                Log.warning("Cannot parse universal link \(incomingURL)")
            }
        }

        return false
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            return false
        }
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        (window?.rootViewController as? MainTabBarController)?.handleNofitication()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        defer { completionHandler(UIBackgroundFetchResult.newData) }
        (window?.rootViewController as? MainTabBarController)?.handleNofitication()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.info("APNs token retrieved: \(deviceToken)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.error("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    

}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
        
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String) {
        
        /// Post notification about FCM token updating
        NotificationCenter.default.post(name: Notification.Name.fcmTokenUpdated, object: nil, userInfo: [Notification.Key.fcmToken: fcmToken])
        Log.info("Firebase registration token updated: \(fcmToken)")
    }
    
    
}

// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Background notification handler
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else {
            return
        }
        (window?.rootViewController as? MainTabBarController)?.handleNofitication()
    }

    // Foreground notification handler
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}

// MARK: - Helpers

extension AppDelegate {

    func setupDepencencies(for application: UIApplication) {
        // Nuke
        let pipeline = ImagePipeline {
            $0.dataLoader = NukeAlamofirePlugin.AlamofireDataLoader()
            $0.imageCache = ImageCache.shared
        }
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.3)
        ImagePipeline.shared = pipeline
        
        // IQKeyboard manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        // Google services
        GMSServices.provideAPIKey(Constants.Google.placesApiKey)
        GMSPlacesClient.provideAPIKey(Constants.Google.placesApiKey)

        // Firebase & Dynamic links & FCM
        FirebaseApp.configure()
    }
    
    func registerForPushNotifications(application: UIApplication) {
        Messaging.messaging().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            guard granted else { return }
            center.delegate = self
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleFCMToken), name: Notification.Name.fcmTokenUpdated, object: nil)
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    @objc func handleFCMToken(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any], let token = data[Notification.Key.fcmToken] as? String {
            APIClient.default.updateDeviceToken(fcmToken: token) { (result) in
                switch result {
                case .success:
                    Log.info("Success updated token in application server")
                case .failure(let erorr):
                    Log.error(erorr.localizedDescription)
                }
            }
        }
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        if AppStorage.User.Profile?.userId == nil || AppStorage.Auth.refreshToken == nil {       // User is not logined yet, or unlogined
            AppStorage.State.pendingDynamicLink = DynamicLinkContainer(dynamicLink: dynamicLink)
        } else {
            (window?.rootViewController as? MainTabBarController)?.handleDynamicLink(dynamicLink)
        }
    }


}
