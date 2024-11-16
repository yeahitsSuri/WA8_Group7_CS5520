//
//  ViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    let mainScreen = MainScreenView()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    var chats: [Chat] = []
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
            self.mainScreen.labelText.isHidden = true
            self.mainScreen.profilePic.isHidden = true
            self.setupRightBarButton(isLoggedin: true)
            self.mainScreen.tableView.isHidden = false
            self.fetchChats()
        } else {
            self.currentUser = nil
            self.mainScreen.labelText.text = "Please sign in to see the chats!"
            self.setupRightBarButton(isLoggedin: false)
            self.mainScreen.tableView.isHidden = true
        }
    }
    
    func fetchChats() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No user email found")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("chats")
            .whereField("participants", arrayContains: currentUserEmail)
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching chats: \(error)")
                    return
                }
                
                var fetchedChats: [Chat] = []
                let group = DispatchGroup() // Synchronize async calls
                
                snapshot?.documents.forEach { document in
                    let data = document.data()
                    guard let participants = data["participants"] as? [String],
                          let lastMessage = data["lastMessage"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else { return }
                    
                    let otherUserEmail = participants.first(where: { $0 != currentUserEmail }) ?? "Unknown"
                    
                    // Use DispatchGroup to handle async name fetching
                    group.enter()
                    self.getUserName(byEmail: otherUserEmail) { name in
                        let otherUserName = name ?? otherUserEmail
                        let chat = Chat(
                            id: document.documentID,
                            name: otherUserName,
                            lastMessage: lastMessage,
                            timestamp: timestamp.dateValue(),
                            participants: participants
                        )
                        fetchedChats.append(chat)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.chats = fetchedChats.sorted(by: { $0.timestamp > $1.timestamp })
                    self.mainScreen.tableView.reloadData()
                }
            }
    }
    
    func getUserName(byEmail email: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user name: \(error)")
                    completion(nil)
                    return
                }
                
                if let document = snapshot?.documents.first {
                    let name = document.data()["name"] as? String
                    completion(name)
                } else {
                    print("No user found with email: \(email)")
                    completion(nil)
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
        chatDetailVC.chatId = chats[indexPath.row].id
        chatDetailVC.title = chats[indexPath.row].name 
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            let chatToDelete = self.chats[indexPath.row]
            self.deleteChat(chatToDelete)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteChat(_ chat: Chat) {
        let db = Firestore.firestore()
        let chatRef = db.collection("chats").document(chat.id)
        
        // First delete all messages in the chat
        chatRef.collection("messages").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting messages: \(error)")
                return
            }
            
            // Delete each message document
            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            // Delete the chat document itself
            batch.deleteDocument(chatRef)
            
            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("Error deleting chat: \(error)")
                } else {
                    // Remove from local array and update UI
                    if let index = self.chats.firstIndex(where: { $0.id == chat.id }) {
                        self.chats.remove(at: index)
                        DispatchQueue.main.async {
                            self.mainScreen.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
