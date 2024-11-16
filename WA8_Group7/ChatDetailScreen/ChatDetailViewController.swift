//
//  ChatListViewController.swift
//  WA8_Group7
//
//  Created by Rebecca Zhang on 11/9/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatDetailViewController: UIViewController {
    
    let chatDetailView = ChatDetailView()
    var chatId: String?
    
    override func loadView() {
        view = chatDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        
        chatDetailView.tableView.delegate = self
        chatDetailView.tableView.dataSource = self
        chatDetailView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        chatDetailView.tableView.refreshControl = refreshControl

        fetchChatHistory()
        scrollToBottom(animated: false)
    }
    
    func fetchChatHistory() {
        guard let chatId = chatId else { return }
        let db = Firestore.firestore()
        db.collection("chats").document(chatId).collection("messages").order(by: "timestamp").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching messages: \(error)")
            } else {
                self.chatDetailView.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
                self.chatDetailView.tableView.reloadData()
                // Only scroll if we have messages
                if !self.chatDetailView.messages.isEmpty {
                    self.scrollToBottom(animated: true)
                }
            }
        }
    }

    private func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            guard self.chatDetailView.messages.count > 0 else { return }
            let indexPath = IndexPath(row: self.chatDetailView.messages.count - 1, section: 0)
            self.chatDetailView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    @objc private func refreshMessages() {
        chatDetailView.tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func sendMessage() {
        guard let text = chatDetailView.messageTextField.text, !text.isEmpty else { return }
        guard let chatId = chatId else {
            print("Chat ID is nil")
            return
        }
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is signed in")
            return
        }
        
        let newMessage = Message(
            senderName: currentUser.displayName ?? "Unknown",
            sender: currentUser.email ?? "Unknown",
            text: text,
            timestamp: Date()
        )
        
        let db = Firestore.firestore()
        db.collection("chats").document(chatId).collection("messages").addDocument(data: [
            "senderName": newMessage.senderName,
            "sender": newMessage.sender,
            "text": newMessage.text,
            "timestamp": newMessage.timestamp
        ]) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.chatDetailView.messages.append(newMessage)
                    self.chatDetailView.messageTextField.text = ""
                    self.chatDetailView.tableView.reloadData()
                    self.scrollToBottom(animated: true)
                    self.updateLatestMessage(text)
                }
            }
        }
    }

    func updateLatestMessage(_ text: String) {
        guard let chatId = chatId else {
            print("Chat ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("chats").document(chatId).updateData([
            "lastMessage": text,
            "timestamp": Date()
        ]) { error in
            if let error = error {
                print("Error updating latest message: \(error)")
            }
        }
    }
}

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDetailView.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatDetailView.messages[indexPath.row]
        let currentUserEmail = Auth.auth().currentUser?.email
        let isCurrentUser = message.sender == currentUserEmail
        
        let identifier = isCurrentUser ? "SelfMessageCell" : "OtherMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.configure(with: message)
        return cell
    }
}
