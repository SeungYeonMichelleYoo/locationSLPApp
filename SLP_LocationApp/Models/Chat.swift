//
//  Chat.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/06.
//
import Foundation

struct Chat: Codable {
    let id: String
    let chat: String
    let createdAt: String
    let from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chat
        case createdAt
        case from
        case to
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        chat = try container.decode(String.self, forKey: .chat)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
    }
    
    init(id: String, chat: String, createdAt: String, from: String, to: String) {
        self.id = id
        self.chat = chat
        self.createdAt = createdAt
        self.from = from
        self.to = to
    }
}
