//
//  Chat.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//
import Foundation

struct Chat: Codable {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let participants: [String]
}
