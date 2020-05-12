//
//  SavedContentViewController.swift
//  CoBook
//
//  Created by protas on 5/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SavedContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationItem.scrollEdgeAppearance = .some(<#T##UINavigationBarAppearance#>)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object Щto the new view controller.
    }
    */

}
