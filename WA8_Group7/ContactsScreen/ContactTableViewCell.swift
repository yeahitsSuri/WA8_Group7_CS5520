//
//  ContactTableViewCell.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/15/24.
//

import UIKit


class ContactTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chat", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var chatButtonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(chatButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chatButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chatButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
    }
    
    @objc private func chatButtonTapped() {
        chatButtonAction?()
    }

    func configure(with contact: Contact, chatAction: @escaping () -> Void) {
        nameLabel.text = contact.name
        chatButtonAction = chatAction
    }
}
