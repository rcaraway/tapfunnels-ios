//
//  UIAlertController+TapKit.swift
//  TapKit
//
//  Created by Rob Caraway on 9/3/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    static func screenNamingPrompt(confirm: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: "Name the screen", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Screen Name"
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
            confirm(alertController)
        }))
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootController.present(alertController, animated: true, completion: nil)
    }
    
    static func showScreenConfirmationPrompt() {
        let alertController = UIAlertController(title: "Screen Created", message: "Screen and all of its views successfully saved to cloud", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootController.present(alertController, animated: true, completion: nil)
    }
    
    static func showScreenFailurePrompt() {
        let alertController = UIAlertController(title: "Failed to Create Screen", message: "Something went wrong.  Check your internet and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootController.present(alertController, animated: true, completion: nil)
    }
    
    static func showVolumeFailurePrompt() {
        let alertController = UIAlertController(title: "Failed to listen to volume", message: "Something went wrong.  Restart the app.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootController.present(alertController, animated: true, completion: nil)
    }

}
