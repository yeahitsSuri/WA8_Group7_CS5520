//
//  ChatListViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//
import UIKit

class ChatListViewController: UIViewController {
    
    private let chatListView = ChatListView()
    
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
    
    override func loadView() {
        view = chatListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        
        chatListView.tableView.delegate = self
        chatListView.tableView.dataSource = self
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
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
