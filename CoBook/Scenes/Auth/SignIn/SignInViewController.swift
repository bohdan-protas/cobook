//
//  SignInViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBAction func signUpButtonTapped(_ sender: UIButton) {

        //self.performSegue(withIdentifier: SignUpViewController.segueId, sender: self)
        self.dismiss(animated: true, completion: nil)
//        let controller: SignUpViewController = UIStoryboard.auth.initiateViewControllerFromType()
//        controller.modalPresentationStyle = .overFullScreen
//        self.present(controller, animated: true, completion: nil)

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
