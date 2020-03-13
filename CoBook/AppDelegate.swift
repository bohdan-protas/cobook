//
//  AppDelegate.swift
//  CoBook
//
//  Created by protas on 2/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        if AppStorage.refreshToken == nil {
            if AppStorage.profile == nil {
                if AppStorage.isUserCompletedTutorial {
                    let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                    window?.rootViewController = signUpNavigationController
                } else {
                    let onboardingViewController: OnboardingViewController = UIStoryboard.auth.initiateViewControllerFromType()
                    window?.rootViewController = onboardingViewController
                }
            } else {
                let signInViewController: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signInViewController
            }


        } else {
            window?.rootViewController = MainTabBarController()

//            window?.rootViewController = LaunchScreenLoaderViewController()
//            APIClient.default.refreshTokenRequest(refreshToken: AppStorage.refreshToken ?? "") { [weak self] (result) in
//                guard let strongSelf = self else { return }
//
//                switch result {
//                case .success(let response):
//                    switch response.status {
//                    case .ok:
//                        AppStorage.accessToken = response.data?.accessToken
//                        strongSelf.window?.rootViewController = MainTabBarController()
//                        print("current user token: \(AppStorage.accessToken)")
//                    case .error:
//                        let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
//                        strongSelf.window?.rootViewController = signUpNavigationController
//                        debugPrint("Error: \(response.errorId ?? ""), \(response.errorDescription ?? "")")
//                    }
//                case .failure(let error):
//                    let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
//                    strongSelf.window?.rootViewController = signUpNavigationController
//                    debugPrint(error.localizedDescription)
//                }
//
//            }
        }

        IQKeyboardManager.shared.enable = true

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.isUserInitiatedRegistration && !AppStorage.isUserCompletedRegistration {
            AppStorage.accessToken = nil
            AppStorage.refreshToken = nil
            AppStorage.profile = nil
            AppStorage.isUserCompletedRegistration = false
            AppStorage.isUserInitiatedRegistration = false
        }
    }


}

