//
//  WelcomeViewController.swift
//  weave
//
//  Created by Karson Braaten on 2017-08-28.
//  Copyright © 2017 Karson Braaten. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var didTapRegister: () -> () = {}
    var didTapLogin: () -> () = {}
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
    }

    @IBAction func showRegister(_ sender: Any) {
        didTapRegister()
    }
    
    @IBAction func showLogin(_ sender: Any) {
        didTapLogin()
    }
    
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
