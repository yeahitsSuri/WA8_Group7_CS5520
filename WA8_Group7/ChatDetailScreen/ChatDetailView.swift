//
//  ChatListView.swift
//  WA8_Group7
//
//  Created by Rebecca Zhang on 11/9/24.
//

import UIKit

class ChatDetailView: UIView {
    
    let tableView: UITableView!
    let messageInputView = UIView()
    let messageTextField = UITextField()
    let sendButton = UIButton(type: .system)
    
    var messages: [Message] = [
        Message(sender: "John", text: "Hello there!", timestamp: Date(), isCurrentUser: false),
        Message(sender: "Me", text: "Hi John!", timestamp: Date(), isCurrentUser: true),
        Message(sender: "John", text: "How are you?", timestamp: Date(), isCurrentUser: false),
        Message(sender: "Me", text: "I'm doing great, thanks!", timestamp: Date(), isCurrentUser: true)
    ]
    
    override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableView()
        setupMessageInputView()
        setupMessageTextField()
        setupSendButton()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        tableView.register(SelfMessageCell.self, forCellReuseIdentifier: "SelfMessageCell")
        tableView.register(OtherMessageCell.self, forCellReuseIdentifier: "OtherMessageCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }
    
    func setupMessageInputView() {
        messageInputView.backgroundColor = .systemGray5
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageInputView)
    }
    
    func setupMessageTextField() {
        messageTextField.borderStyle = .roundedRect
        messageTextField.placeholder = "Type a message..."
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(messageTextField)
    }
    
    func setupSendButton() {
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(sendButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            messageInputView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            messageInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 50),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 8),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor)
        ])
    }
}
