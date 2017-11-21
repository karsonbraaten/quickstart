//
//  LoginViewController.swift
//  weave
//
//  Created by Karson Braaten on 2017-08-28.
//  Copyright © 2017 Karson Braaten. All rights reserved.
//

import UIKit

import FirebaseAuth

class LoginViewController: UIViewController {
    
    var didLogin: (_ user: User) -> () = {_ in }
    var didClose: () -> () = {}
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        emailOutlet.becomeFirstResponder()
    }
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBAction func login(_ sender: Any) {
        let email = emailOutlet.text!
        let password = passwordOutlet.text!
        AuthService.shared.login(withEmail: email, password: password) { (user, error) in
            if let currentUser = user {
                self.view.endEditing(true)
                self.didLogin(currentUser)
            } else {
                AlertService.shared.presentAlert(title: error!.localizedDescription, message: nil, in: self)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        view.endEditing(true)
        didClose()
    }
    
}
