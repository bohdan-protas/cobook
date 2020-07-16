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
import FirebaseDynamicLinks
import Nuke
import NukeAlamofirePlugin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Clear saved data in keychain if user reinstalled app
        if AppStorage.State.isFirstAppLaunch {
            AppStorage.deleteAllData()
            AppStorage.State.isFirstAppLaunch = false
        }

        setupAppearence()
        setupDepencencies()
        setupScreenToOpen()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.User.isUserInitiatedRegistration && !AppStorage.User.isUserCompletedRegistration {
            AppStorage.Auth.deleteAllData()
            AppStorage.User.Profile = nil
            AppStorage.User.isUserInitiatedRegistration = false
        }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            // parse dynamic link
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            return false
        }
    }


}

// MARK: - Dynamic link hanling

extension AppDelegate {

    func setupScreenToOpen() {
        window = UIWindow(frame: UIScreen.main.bounds)

        // MARK: Screen routing
        if AppStorage.User.Profile?.userId == nil {
            if AppStorage.User.isTutorialShown {
                let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signUpNavigationController
            } else {
                AppStorage.User.isTutorialShown = true
                let onboardingViewController: OnboardingViewController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = onboardingViewController
            }
        } else {
            if AppStorage.Auth.refreshToken == nil {
                let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signInNavigationController
            } else {
                window?.rootViewController = MainTabBarController()
            }
        }

        window?.makeKeyAndVisible()
    }

    func setupDepencencies() {
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

        // Firebase & Dynamic links
        FirebaseApp.configure()

    }

    func setupAppearence() {
        UINavigationBar.appearance().tintColor = UIColor.Theme.blackMiddle
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 26), .foregroundColor: UIColor.Theme.blackMiddle]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.Theme.grayBG

        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.Theme.greenDark

        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle.withAlphaComponent(0.5)], for: .disabled)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle.withAlphaComponent(0.5)], for: .highlighted)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.grayUI], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.greenDark], for: .selected)
    }


}

// MARK: - Routing

extension AppDelegate {

    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        if AppStorage.User.Profile?.userId == nil || AppStorage.Auth.refreshToken == nil {       // User is not logined yet, or unlogined
            AppStorage.State.pendingDynamicLink = DynamicLinkContainer(dynamicLink: dynamicLink)
        } else {
            (window?.rootViewController as? MainTabBarController)?.handleDynamicLink(dynamicLink)
        }
    }


}
