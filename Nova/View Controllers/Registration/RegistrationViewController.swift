//
//  RegistrationViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit
//import FirebaseAuth

class RegistrationViewController: UIViewController {
        
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var therapistLoginButton: UIButton!
    @IBOutlet weak var patientLoginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    


    @IBAction func createAccountButtonTapped(_ sender: Any) {
        configureVCForNewAccountForm()
        createAccountButton.isHidden = false
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func patientLoginButtonTapped(_ sender: UIButton) {
        navigateToMessagesVC()
        
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
        createAccountButton.isHidden = true
        createAccountButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        patientLoginButton.layer.cornerRadius = 5
        therapistLoginButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configureVCForNewAccountForm() {
        forgotPasswordButton.isHidden = true
        therapistLoginButton.isHidden = true
        patientLoginButton.isHidden = true
        signUpButton.isHidden = true
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


}
