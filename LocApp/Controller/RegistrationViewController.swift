//
//  RegistrationViewController.swift
//  LocApp
//
//  Created by Musa Lheureux on 23/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    // MARK: - Properties
    var user: User!
    
    // MARK: - Outlets
    @IBOutlet var textFields: [UITextField]! // All text fields, sorted by display order.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.textFields.first?.becomeFirstResponder()
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
    
}

// MARK: - Validate
extension RegistrationViewController {
    
    @IBAction func validate() {
        self.createUserObject()
        self.checkUserStatus()
    }
    
    private func createUserObject() {
        let lastName = self.textFields[0].text
        let firstName = self.textFields[1].text
        let email = self.textFields[2].text
        let password1 = self.textFields[3].text
        let password2 = self.textFields[4].text
        
        self.user = User(lastName: lastName, firstName: firstName, email: email, password: password1, password2: password2  )
    }
    
    private func checkUserStatus() {
        switch self.user.status {
        case .accepted:
            self.saveUser()
        case .rejected(let error):
            self.presentAlert(with: error)
        }
    }
    
    private func saveUser() {
        guard let jsonData = try? JSONEncoder().encode(self.user) else {
            return
        }
        Network.post(jsonData: jsonData, path: "/posts") { (clientError, errorCode, data) in
            if let error = clientError {
                fatalError(error.localizedDescription)
            } else if let error = errorCode {
                print(error)
            } else {
                //
                self.performSegue(withIdentifier: "segueToRegistrationSuccess", sender: nil)
            }
        }
    }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Navigation
extension RegistrationViewController {
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRegistrationSuccess" {
            // Get the new view controller using segue.destinationViewController.
            let registrationSuccessVC = segue.destination as! RegistrationSuccessViewController
            // Pass the selected object to the new view controller.
            registrationSuccessVC.user = self.user
        }
    }

}

// MARK: - Keyboard
extension RegistrationViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        for textField in self.textFields {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextIndex = self.textFields.index(after: self.textFields.index(of: textField)!)
        if nextIndex != self.textFields.count {
            self.textFields[nextIndex].becomeFirstResponder()
        } else if nextIndex == self.textFields.count {
            self.validate()
        }
        return true
    }
    
}
