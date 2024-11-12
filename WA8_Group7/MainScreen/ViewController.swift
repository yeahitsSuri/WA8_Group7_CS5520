//
//  ViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//
import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    let mainScreen = MainScreenView()

    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the chats!"
                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.setupRightBarButton(isLoggedin: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Instantiate ChatListViewController
        let chatListVC = ChatListViewController()
        
        navigationController?.pushViewController(chatListVC, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
}

