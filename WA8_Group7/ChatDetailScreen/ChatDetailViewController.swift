//
//  ChatListViewController.swift
//  WA8_Group7
//
//  Created by Rebecca Zhang on 11/9/24.
//

import UIKit

class ChatDetailViewController: UIViewController {
    
    let chatDetailView = ChatDetailView()
    
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
    
        scrollToBottom(animated: false)
    }

    private func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatDetailView.messages.count - 1, section: 0)
            self.chatDetailView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    @objc private func refreshMessages() {
        chatDetailView.tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func sendMessage() {
        guard let text = chatDetailView.messageTextField.text, !text.isEmpty else { return }
        
        let newMessage = Message(sender: "Me", text: text, timestamp: Date(), isCurrentUser: true)
        chatDetailView.messages.append(newMessage)
        chatDetailView.messageTextField.text = ""
        
        chatDetailView.tableView.reloadData()
        scrollToBottom(animated: true)
    }
}

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDetailView.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatDetailView.messages[indexPath.row]
        let identifier = message.isCurrentUser ? "SelfMessageCell" : "OtherMessageCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.configure(with: message)
        return cell
    }
}
