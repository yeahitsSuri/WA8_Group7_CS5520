//
//  SelfMessageCell.swift
//  WA8_Group7
//
//  Created by Rebecca Zhang on 11/9/24.
//

import UIKit

class SelfMessageCell: UITableViewCell, MessageCell {
    var senderLabel: UILabel!
    var messageLabel: UILabel!
    var timestampLabel: UILabel!
    var wrapperView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperView()
        setupSenderLabel()
        setupMessageLabel()
        setupTimeStampLabel()
        initConstraints()
    }
    
    func setupWrapperView() {
        wrapperView = UIView()
        wrapperView.backgroundColor = UIColor.systemBlue
        wrapperView.layer.cornerRadius = 16
        wrapperView.clipsToBounds = true
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrapperView)
    }
    
    func setupSenderLabel() {
        senderLabel = UILabel()
        senderLabel.font = .systemFont(ofSize: 14)
        senderLabel.textColor = .white
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(senderLabel)
    }
    
    func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(messageLabel)
    }
    
    func setupTimeStampLabel() {
        timestampLabel = UILabel()
        timestampLabel.font = .systemFont(ofSize: 12)
        timestampLabel.textColor = .white
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(timestampLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wrapperView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.6),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            senderLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 8),
            senderLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            senderLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -8),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            timestampLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -8),
            timestampLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: Message) {
        senderLabel.text = "Me"
        messageLabel.text = message.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        timestampLabel.text = dateFormatter.string(from: message.timestamp)
    }
}
