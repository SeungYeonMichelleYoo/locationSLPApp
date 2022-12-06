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
}
