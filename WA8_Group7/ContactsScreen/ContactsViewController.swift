//
//  Chat.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/15/24.
//
import UIKit
import FirebaseFirestore

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
        // Logic to initiate a new chat with the contact
        // For example, add the chat to the chat list and navigate to the chat detail screen
        let newChat = Chat(name: contact.name, lastMessage: "", timestamp: Date())
        // Assuming you have a reference to the main screen or chat list
        // mainScreen.chats.append(newChat)
        // Navigate to chat detail screen
        let chatDetailVC = ChatDetailViewController()
        chatDetailVC.title = contact.name
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}
