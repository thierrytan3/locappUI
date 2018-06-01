//
//  LoginViewController.swift
//  LocApp
//
//  Created by Musa Lheureux on 23/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    var email: String?
    var password: String?
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func validate() {
        self.setLoginProperties()
        self.login()
    }
    
    private func setLoginProperties() {
        self.email = self.emailTextField.text
        self.password = self.passwordTextField.text
    }
    
    private func login() {
        if self.email != nil && self.email != "" && self.password != nil && self.password != "" {
            //
            UserDefaults.standard.set(true, forKey: "status")
            Switcher.updateRootVC()
        }
    }
    
    // Cette méthode déclare le contrôleur comme cible potentielle d'un unwind segue.
    // Note : on peut écrire du code à l'intérieur, si on a besoin d'effectuer une action lorsqu'on sera revenu à l'interface Login.
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        let registrationSuccessVC = segue.source as! RegistrationSuccessViewController
        self.emailTextField.text = registrationSuccessVC.user.email
        self.passwordTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup before appearing the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appearing the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup before disappearing the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Do any additional setup after disappearing the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Keyboard
extension LoginViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.validate()
        }
        return true
    }
}
