//
//  SelectAlbumViewController.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SelectAlbumViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    @IBAction func addAlbumTapped(_ sender: Any) {
        performSegue(to: CreateAlbumViewController.self, sender: self) { (viewController) in

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
