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

        let allCardsController: CardsOverviewNavigationController = UIStoryboard.allCards.initiateViewControllerFromType()
        allCardsController.tabBarItem = UITabBarItem(title: "AllCards".localized, image: #imageLiteral(resourceName: "ic_tabbar_allcards_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_allcards_active"))
        allCardsController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .normal)
        allCardsController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .selected)
        allCardsController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.grayUI], for: .normal)
        allCardsController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.greenDark], for: .selected)

        self.viewControllers = [allCardsController, accountController]
        self.selectedIndex = 0
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
