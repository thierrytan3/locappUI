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
    struct Authenticator: Codable {
        var username: String?
        var password: String?
        var token: String?
        var id: String?
    }
    var authenticator: Authenticator!
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func validate() {
        self.createAuthenticatorObject()
        self.login()
    }
    
    private func createAuthenticatorObject() {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        self.authenticator = Authenticator(username: username, password: password, token: nil, id: nil)
    }
    
    private func login() {
        if self.authenticator.username != nil && self.authenticator.username != "" && self.authenticator.password != nil && self.authenticator.password != "" {
            guard let jsonData = try? JSONEncoder().encode(self.authenticator) else {
                return
            }
            Network.post(path: "/authentication", jsonData: jsonData) { (error, responseJson) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.presentAlert(with: "Username ou mot de passe invalide.")
                    }
                    else if let responseJson = responseJson {
                        let decoder = JSONDecoder()
                        let authenticator = try! decoder.decode(Authenticator.self, from: responseJson)
                        print(authenticator)
                        Network.setUserId(userId: authenticator.id!)
                        UserDefaults.standard.set(authenticator.id!, forKey: "id")
                        UserDefaults.standard.set(authenticator.token!, forKey: "token")
                        Network.setToken(token: authenticator.token!)
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        Switcher.updateRootVC()
                        
                    }
                }
                    
            }
            
        }
    }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Cette méthode déclare le contrôleur comme cible potentielle d'un unwind segue.
    // Note : on peut écrire du code à l'intérieur, si on a besoin d'effectuer une action lorsqu'on sera revenu à l'interface Login.
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        let registrationSuccessVC = segue.source as! RegistrationSuccessViewController
        self.usernameTextField.text = registrationSuccessVC.user.username
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
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.validate()
        }
        return true
    }
}
