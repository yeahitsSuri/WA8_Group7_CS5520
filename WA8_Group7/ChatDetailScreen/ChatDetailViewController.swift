//
//  ChatListViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//

import UIKit

class ChatListViewController: UIViewController {
    
    let chatListView = ChatListView()
    
    override func loadView() {
        view = chatListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        
        // Setup delegates
        chatListView.tableView.delegate = self
        chatListView.tableView.dataSource = self
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        chatListView.tableView.refreshControl = refreshControl
    
        scrollToBottom(animated: false)
    }

    // Helper method for scrolling to bottom
    private func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatListView.messages.count - 1, section: 0)
            self.chatListView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    @objc private func refreshMessages() {
        chatListView.tableView.refreshControl?.endRefreshing()
    }
}



// MARK: - UITableView Delegate & DataSource
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListView.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCellView
        
        let message = chatListView.messages[indexPath.row]
        cell.configure(
            sender: message.sender,
            message: message.text,
            timestamp: message.timestamp,
            isCurrentUser: message.isCurrentUser
        )
        
        return cell
    }
}
