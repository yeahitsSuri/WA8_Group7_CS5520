//
//  MessageTableCellView.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//

import UIKit

class MessageTableCellView: UITableViewCell {
    
    // MARK: - UI Elements
    var wrapperView: UIView!
    var senderLabel: UILabel!
    var messageLabel: UILabel!
    var timestampLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        wrapperView = UIView()
        wrapperView.layer.cornerRadius = 8
        wrapperView.clipsToBounds = true
        contentView.addSubview(wrapperView)
        
        senderLabel = UILabel()
        senderLabel.font = .boldSystemFont(ofSize: 16)
        wrapperView.addSubview(senderLabel)
        
        messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        wrapperView.addSubview(messageLabel)
        
        timestampLabel = UILabel()
        timestampLabel.font = .systemFont(ofSize: 12)
        timestampLabel.textColor = .gray
        wrapperView.addSubview(timestampLabel)
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            senderLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 8),
            senderLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            senderLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -8),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            timestampLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(sender: String, message: String, timestamp: Date, isCurrentUser: Bool) {
        senderLabel.text = sender
        messageLabel.text = message
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
        // Style based on sender
        if isCurrentUser {
            wrapperView.backgroundColor = UIColor.systemGray5
            contentView.layoutMargins = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 16)
        } else {
            wrapperView.backgroundColor = .white
            contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 48)
        }
    }
}
