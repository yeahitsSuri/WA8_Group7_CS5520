//
//  RightBarButtonManager.swift
//  projecttest
//
//  Created by Kay‘s MacPro on 11/11/24.
//

import UIKit
import FirebaseAuth

extension ViewController{
    func setupRightBarButton(isLoggedin: Bool){
        if isLoggedin{
            //MARK: user is logged in...
            let logoutButton = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [logoutButton]
            
        }else{
            //MARK: not logged in...
            let signInButton = UIBarButtonItem(
                title: "Sign In",
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            
            let registerButton = UIBarButtonItem(
                title: "Register",
                style: .plain,
                target: self,
                action: #selector(onRegisterBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [signInButton, registerButton]
        }
    }

    @objc func onRegisterBarButtonTapped(){
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func onSignInBarButtonTapped() {
        let signInAlert = UIAlertController(title: "Sign In", message: "Enter your credentials", preferredStyle: .alert)
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Enter email"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Enter password"
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
            if let email = signInAlert.textFields?[0].text,
            let password = signInAlert.textFields?[1].text {
                self.signInToFirebase(email: email, password: password)
            }
        }
        
        signInAlert.addAction(signInAction)
        
        self.present(signInAlert, animated: true) {
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        }
    }
    
    
    func signInToFirebase(email: String, password: String){
        //MARK: can you display progress indicator here?
        //MARK: authenticating the user...
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                //MARK: user authenticated...
                //MARK: can you hide the progress indicator here?
            }else{
                //MARK: alert that no user found or password wrong...
            }
        })
    }
    
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }

    
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                }catch{
                    print("Error occured!")
                }
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }

    
}
