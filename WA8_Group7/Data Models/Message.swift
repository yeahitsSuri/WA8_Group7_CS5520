//
//  Message.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//

import Foundation

struct Message: Codable {
    var sender: String
    let text: String
    let timestamp: Date
}
