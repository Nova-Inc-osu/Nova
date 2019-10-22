//
//  RegistrationViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
        
    @IBOutlet weak var therapistLoginButton: UIButton!
    @IBOutlet weak var patientLoginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBAction func patientLoginButtonTapped(_ sender: UIButton) {
        
        guard let password = passwordTextField.text else {
            showAlert(message: "Please enter a password.")
            return
        }
        
        guard let username = usernameTextField.text else {
            showAlert(message: "Please enter a username.")
            return
        }
        
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
           if error == nil {
             self.navigateToMessagesVC()
            }
            else {
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
            }
        }
                
    }
    
    
    @IBAction func therapistLoginButtonTapped(_ sender: UIButton) {
        navigateToPatientListVC()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func configureVC() {
        patientLoginButton.layer.cornerRadius = 5
        therapistLoginButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
    }
    
    /**
     Navigate to MessagesVC
     */
    func navigateToMessagesVC() {
        let navigationController = UINavigationController(rootViewController: ChatViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    /**
     Navigate to MessagesVC
     */
    func navigateToPatientListVC() {
        let navigationController = UINavigationController(rootViewController: PatientListViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    


}
