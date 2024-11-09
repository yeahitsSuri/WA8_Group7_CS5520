//
//  ChatListView.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//

import UIKit

class ChatListView: UIView {
    
    // MARK: - UI Elements
    let tableView: UITableView!
    
    var messages: [Message] = [
        Message(sender: "John", text: "Hello there!", timestamp: Date(), isCurrentUser: false),
        Message(sender: "Me", text: "Hi John!", timestamp: Date(), isCurrentUser: true),
        Message(sender: "John", text: "How are you?", timestamp: Date(), isCurrentUser: false),
        Message(sender: "Me", text: "I'm doing great, thanks!", timestamp: Date(), isCurrentUser: true)
    ]
    
    override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        self.backgroundColor = .white
        
        // Setup TableView
        tableView.register(TableCellView.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        addSubview(tableView)
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
