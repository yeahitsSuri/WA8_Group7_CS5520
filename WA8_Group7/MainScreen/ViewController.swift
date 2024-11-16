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
    
    var chats: [Chat] = [
        Chat(name: "John Doe",
             lastMessage: "Hey, how are you?",
             timestamp: Date()), // Today
        Chat(name: "Jane Smith",
             lastMessage: "Let's catch up soon!",
             timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        Chat(name: "Group Chat",
             lastMessage: "Meeting at 5 PM",
             timestamp: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 1))!)
    ]

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
                self.mainScreen.tableView.isHidden = true
                
            }else{
                self.currentUser = user
                self.mainScreen.labelText.isHidden = true
                self.mainScreen.profilePic.isHidden = true 
                self.setupRightBarButton(isLoggedin: true)
                self.mainScreen.tableView.isHidden = false
                self.mainScreen.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        mainScreen.tableView.delegate = self
        mainScreen.tableView.dataSource = self
        mainScreen.tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: "ChatListCell")

        let contactsButton = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(showContacts))
        navigationItem.rightBarButtonItem = contactsButton

        mainScreen.contactsButton.addTarget(self, action: #selector(showContacts), for: .touchUpInside) // Add this line
    }

    @objc func showContacts() {
        let contactsVC = ContactsViewController()
        navigationController?.pushViewController(contactsVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if user == nil {
                    self.currentUser = nil
                    self.mainScreen.labelText.text = "Please sign in to see the chats!"
                    self.setupRightBarButton(isLoggedin: false)
                    self.mainScreen.tableView.isHidden = true
                } else {
                    self.currentUser = user
                    self.mainScreen.labelText.isHidden = true
                    self.mainScreen.profilePic.isHidden = true
                    self.setupRightBarButton(isLoggedin: true)
                    self.mainScreen.tableView.isHidden = false
                    self.mainScreen.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        let chat = chats[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatDetailVC = ChatDetailViewController()
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}
