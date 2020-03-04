//
//  MainTabBarController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false

        let accountController: AccountNavigationController = UIStoryboard.account.initiateViewControllerFromType()
        accountController.tabBarItem = UITabBarItem(title: "Account".localized, image: #imageLiteral(resourceName: "ic_tabbar_account_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_account_active"))

        accountController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .normal)
        accountController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .selected)
        accountController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.grayUI], for: .normal)
        accountController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.greenDark], for: .selected)

        self.viewControllers = [accountController]
    }

    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
