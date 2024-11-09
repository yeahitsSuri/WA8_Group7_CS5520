//
//  ChatListViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
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
        
        // Setup delegates
        chatDetailView.tableView.delegate = self
        chatDetailView.tableView.dataSource = self
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        chatDetailView.tableView.refreshControl = refreshControl
    
        scrollToBottom(animated: false)
    }

    // Helper method for scrolling to bottom
    private func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatDetailView.messages.count - 1, section: 0)
            self.chatDetailView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    @objc private func refreshMessages() {
        chatDetailView.tableView.refreshControl?.endRefreshing()
    }
}



// MARK: - UITableView Delegate & DataSource
extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDetailView.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableCellView
        
        let message = chatDetailView.messages[indexPath.row]
        cell.configure(
            sender: message.sender,
            message: message.text,
            timestamp: message.timestamp,
            isCurrentUser: message.isCurrentUser
        )
        
        return cell
    }
}
