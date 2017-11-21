//
//  App.swift
//  greasing-the-groove
//
//  Created by Karson Braaten on 2017-09-29.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import UIKit

final class App {
    
    let window: UIWindow
    
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = window.rootViewController as! UINavigationController
        
        AuthService.shared.currentUser != nil ? showWorkouts() : showWelcome()

        AuthService.shared.authState = { auth, user in
            if user == nil {
                self.showWelcome()
            }
        }

    }
    
    func showWelcome() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let welcomeNC = storyboard.instantiateViewController(withIdentifier: "Welcome") as! UINavigationController
        let welcomeVC = welcomeNC.viewControllers[0] as! WelcomeViewController
        welcomeVC.didTapRegister = showRegister
        welcomeVC.didTapLogin = showLogin
        
        setRootViewController(to: welcomeNC)
        navigationController = welcomeNC
    }
    
    func showRegister() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        registerVC.didRegister = { user in
            self.showWorkouts()
        }
        
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showLogin() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginNC = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
        let loginVC = loginNC.viewControllers[0] as! LoginViewController
        
        loginVC.didLogin = { user in
            self.showWorkouts()
        }
        loginVC.didClose = {
            self.navigationController.dismiss(animated: true, completion: nil)
        }
        
        navigationController.present(loginNC, animated: true, completion: nil)
    }
    
    func showWorkouts() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        
        setRootViewController(to: tabBarController)
    }
    
    fileprivate func setRootViewController(to viewController: UIViewController) {
        self.window.makeKeyAndVisible()
        self.window.rootViewController = viewController
    }
    
}
