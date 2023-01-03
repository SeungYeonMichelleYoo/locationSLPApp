//
//  ChatRealm.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/03.
//
import Foundation
import RealmSwift

class ChatRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
       
    convenience init(id: String, to: String, from: String, chat: String, createdAt: String) {
        self.init()
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}
