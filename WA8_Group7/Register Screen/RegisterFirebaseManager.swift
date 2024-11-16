//
//  RegisterFirebaseManager.swift
//  projecttest
//
//  Created by Kay‘s MacPro on 11/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension RegisterViewController{
    
    func registerNewAccount(){
        
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
            if error == nil {
                self.setNameOfTheUserInFirebaseAuth(name: name)
                let db = Firestore.firestore()
                db.collection("users").document(result!.user.uid).setData([
                    "name": name,
                    "email": email
                ])
            } else {
                print(error)
            }
        })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                self.hideActivityIndicator()
                //MARK: the profile update is successful...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
}
