//
//  Chat.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/15/24.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContactsViewController: UIViewController {
    var contacts: [Contact] = []
    let contactsView = ContactsView()

    override func loadView() {
        view = contactsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        contactsView.tableView.delegate = self
        contactsView.tableView.dataSource = self
        contactsView.backgroundColor = .white
        contactsView.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        fetchContacts()
    }

    func fetchContacts() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching contacts: \(error)")
            } else {
                self.contacts = snapshot?.documents.compactMap { document in
                    try? document.data(as: Contact.self)
                } ?? []
                self.contactsView.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let contact = contacts[indexPath.row]
        cell.configure(with: contact) { [weak self] in
            self?.initiateChat(with: contact)
        }
        return cell
    }

    private func initiateChat(with contact: Contact) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }
        
        let db = Firestore.firestore()
        let newChatRef = db.collection("chats").document()
        let currentTime = Date()
        
        let newChat = Chat(
            id: newChatRef.documentID,
            name: contact.name,
            lastMessage: "",
            timestamp: currentTime,
            participants: [currentUser.email ?? "Unknown", contact.email]
        )
        
        newChatRef.setData([
            "id": newChat.id,
            "name": newChat.name,
            "lastMessage": newChat.lastMessage,
            "timestamp": newChat.timestamp,
            "participants": newChat.participants
        ]) { error in
         
            if let error = error {
                print("Error saving chat: \(error)")
                return
            }
            
            // Add the new chat to the chat list
            if let mainVC = self.navigationController?.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
                mainVC.chats.append(newChat)
                mainVC.mainScreen.tableView.reloadData()
            }
            
            // Navigate to chat detail screen
            let chatDetailVC = ChatDetailViewController()
            chatDetailVC.chatId = newChat.id
            chatDetailVC.title = contact.name
            self.navigationController?.pushViewController(chatDetailVC, animated: true)
        }
    }
}
