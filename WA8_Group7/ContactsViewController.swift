//
//  Chat.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/15/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ContactsViewController: UIViewController {
    var contacts: [User] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        setupTableView()
        fetchContacts()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func fetchContacts() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching contacts: \(error)")
            } else {
                self.contacts = snapshot?.documents.compactMap { document in
                    try? document.data(as: User.self)
                } ?? []
                self.tableView.reloadData()
            }
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
}