//
//  UIViewControllerExtension.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/27/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
}
