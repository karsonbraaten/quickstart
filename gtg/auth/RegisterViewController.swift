//
//  RegisterViewController.swift
//  weave
//
//  Created by Karson Braaten on 2017-08-28.
//  Copyright © 2017 Karson Braaten. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    var didRegister: (_ user: User) -> () = {_ in }

    let fbLoginButton = FBSDKLoginButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.readPermissions = ["public_profile", "email"]
        fbLoginButton.delegate = self
    }
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBAction func continueWithFacebook(_ sender: UIButton) {
        fbLoginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        let email = emailOutlet.text!
        let password = passwordOutlet.text!
        AuthService.shared.create(withEmail: email, password: password) { (user, error) in
            if let user = user {
                self.view.endEditing(true)
                self.didRegister(user)
            } else {
                AlertService.shared.presentAlert(title: error!.localizedDescription, message: nil, in: self)
            }
        }
    }
    
}

extension RegisterViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            AlertService.shared.presentAlert(title: error.localizedDescription, message: nil, in: self)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let user = user {
                self.view.endEditing(true)
                self.didRegister(user)
            } else {
                AlertService.shared.presentAlert(title: error!.localizedDescription, message: nil, in: self)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}
}
