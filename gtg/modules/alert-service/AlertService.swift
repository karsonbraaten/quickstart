//
//  AlertService.swift
//  gtg
//
//  Created by Karson Braaten on 2017-11-03.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import UIKit

struct AlertService {

    static let shared = AlertService()
    
    private init() {}
    
    func presentAlert(title: String?, message: String?, in viewController: UIViewController) {
        
        let action = AlertAction(title: "OK", style: .default, handler: nil)
        
        let alert = Alert(
            title: title,
            message: message,
            style: .alert,
            actions: [action]
        )
        
        self.present(alert: alert, in: viewController)
    }
    
    private struct Alert {
        let title: String?
        let message: String?
        let style: UIAlertControllerStyle
        let actions: [AlertAction]?
    }
    
    private struct AlertAction {
        let title: String
        let style: UIAlertActionStyle?
        let handler: ((UIAlertAction) -> Void)?
    }
    
    private func present(alert: Alert, in viewController: UIViewController) {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: alert.style
        )
        
        if let actions = alert.actions {
            actions.forEach { config in
                let action = UIAlertAction(title: config.title, style: config.style ?? .default, handler: config.handler)
                alertController.addAction(action)
            }
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
