//
//  AppDelegate.swift
//  gtg
//
//  Created by Karson Braaten on 2017-11-15.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var app: App?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if let window = window {
            app = App(window: window)
        }
        
        return true
    }

}
