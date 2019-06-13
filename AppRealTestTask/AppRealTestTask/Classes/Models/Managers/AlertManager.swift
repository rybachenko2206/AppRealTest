//
//  AlertManager.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit


class AlertManager {
    
    class func showNameIsNotCorrect(to viewController: UIViewController?) {
        let title = "Error"
        let message = "Name is not correct"
        AlertManager.simpleAlert(title: title, message: message, controller: viewController)
    }
    
    
    class func simpleAlert(title: String,
                           message: String,
                           controller: UIViewController?,
                           completion: Completion? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oklAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        })
        alertController.addAction(oklAction)
        controller?.present(alertController, animated: true, completion: nil)
    }
}
