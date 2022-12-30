//
//  Chat.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/06.
//
import Foundation

struct Chat: Codable {
    let id: String
    let to: String
    let from: String
    let chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to
        case from
        case chat
        case createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        to = try container.decode(String.self, forKey: .to)
        from = try container.decode(String.self, forKey: .from)
        chat = try container.decode(String.self, forKey: .chat)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
    
    init(id: String, to: String, from: String, chat: String, createdAt: String) {
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}

struct FetchingChatModel: Codable {
    let payload: [Chat]
}
