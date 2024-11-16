//
//  RegisterViewController.swift
//  projecttest
//
//  Created by Kay‘s MacPro on 11/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    let childProgressView = ProgressSpinnerViewController()
    let registerView = RegisterView()
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateInputs() -> Bool {
        if let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text,
           let repeatPassword = registerView.textFieldRepeatPassword.text {
            
            if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
                showAlert(message: "All fields are required.")
                return false
            }
            
            if !isValidEmail(email) {
                showAlert(message: "Please enter a valid email address.")
                return false
            }

            if password.count < 6 {
            showAlert(message: "Password must be 6 characters or more.")
                return false
            }
            
            if password != repeatPassword {
                showAlert(message: "Passwords do not match. Please try again.")
                return false
            }
            
            return true
        } else {
            showAlert(message: "All fields are required.")
            return false
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func onRegisterTapped(){
        if validateInputs() {
            registerNewAccount()
        }
    }
}
