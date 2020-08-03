//
//  UIViewController+Extension.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 6/23/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import UIKit

extension UIViewController {
    //MARK: ADD LOCATION ACTION
    
    
    @IBAction func addLocation(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    //MARK: ENABLE AND AND DISABLE STATE FOR BUTTONS
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            button.alpha = 1.0
        }
        else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    //MARK: SHOW ALERT
    
    func showAlert(message: String, tittle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
        }
    
    //MARK: WILL OPEN LINKS IN SAFARI
    
    func openLink(_ url: String){
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot Open link", tittle: "Invalid Link")
            return
        } 
        UIApplication.shared.open(url, options: [:])
    }
}

