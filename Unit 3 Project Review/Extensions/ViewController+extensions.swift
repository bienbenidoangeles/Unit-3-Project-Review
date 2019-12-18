//
//  ViewController+extensions.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/16/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(title: String, message: String, completion: ((UIAlertAction)->Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "OK", style: .default, handler: completion)
        alertController.addAction(alertButton)
        present(alertController, animated: true, completion: nil)
    }
}
