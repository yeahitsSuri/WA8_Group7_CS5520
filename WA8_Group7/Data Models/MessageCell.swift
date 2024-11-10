//
//  MessageCell.swift
//  WA8_Group7
//
//  Created by Rebecca Zhang on 11/9/24.
//

import Foundation
import UIKit

protocol MessageCell: UITableViewCell{
    func configure(with message: Message)
}
