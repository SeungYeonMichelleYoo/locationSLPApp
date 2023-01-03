//
//  ChatListRepository.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/03.
//

import Foundation
import RealmSwift

class ChatListRepository {
    
    let localRealm = try! Realm(configuration: Realm.Configuration(
        schemaVersion: 1,
        
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
               
            }
        }
    ))
    
    var loadedChats: Results<ChatRealm>!
    
    //MARK: - 채팅 전송 버튼 클릭시, 실시간으로 채팅 불러올때(상대가 메시지 보낸 경우)
    func saveChat(data: ChatRealm) {
        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - pagenation 위해 최신 날짜 이전의 Realm DB 불러오기 (20개씩)
    func loadDBChats(myUid: String, matchedUid: String, lastDate: String) -> [Chat] {
        var dbChats:[Chat] = []
        loadedChats = localRealm.objects(ChatRealm.self).filter("to == '\(myUid)' OR from == '\(matchedUid)' OR from == '\(myUid)' OR from == '\(matchedUid)' AND createdAt < '\(lastDate)")
        for i in 0..<20 {
            var chat: Chat = Chat(id: loadedChats[i].id, to: loadedChats[i].to, from: loadedChats[i].from, chat: loadedChats[i].chat, createdAt: loadedChats[i].createdAt)
            if i == 0 {
                dbChats.append(chat)
            } else {
                dbChats.insert(chat, at: 0)
            }
        }
        return dbChats
    }
    
    //MARK: - 최신 채팅날짜 추출(Realm에 가장 마지막에 저장된 createdAt 날짜)
    func getLastChatDate(myUid: String, matchedUid: String) -> String {
        loadedChats = localRealm.objects(ChatRealm.self).filter("to == '\(myUid)' OR from == '\(matchedUid)' OR from == '\(myUid)' OR from == '\(matchedUid)'").sorted(byKeyPath: "createdAt", ascending: false)
        if let lastChat = loadedChats.first {
            var date = String(lastChat.createdAt.split(separator: "T")[0])
            print("getLastChatDate - \(date)")
            return date
        } else {
            print("getLastChatDate - no data")
            return "2000-01-01"
        }
    }
    
}
