//
//  Switcher.swift
//  LocApp
//
//  Created by Musa Lheureux on 30/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNavigationViewController") as! UINavigationController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}
