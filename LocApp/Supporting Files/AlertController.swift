//
//  AlertController.swift
//  LocApp
//
//  Created by Musa Lheureux on 06/06/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import UIKit

class AlertController {
    
    static func presentAlert(_ view: UIViewController, with error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
    static func presentAlertInfo(_ view: UIViewController, with info: String) {
        let alert = UIAlertController(title: "Info", message: info, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
}
