//
//  UIViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 26/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Function that creates an alert message
    ///
    /// - Parameters:
    ///   - title: title for the alert
    ///   - message: message to be displayed in the alert
    /// - Returns: the UIAlertController
    func messageAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: { (action: UIAlertAction) in
            print("Close button tapped")
        })
        alertController.addAction(closeAction)
        return alertController
    }
}
