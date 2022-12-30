//
//  ChatViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/30.
//
import Foundation
import KeychainSwift
import FirebaseAuth

class ChatViewModel {
    
    //채팅 보내기
    func sendChatVM(chat: String, to: String, completion: @escaping (Chat?, Int?) -> Void) {
        ChatAPI.sendChat(chat: chat, to: to) { chat, statusCode, error in
            completion(chat, statusCode)
        }
    }
    
    //채팅 받아오기
    func fetchChatVM(from: String, lastchatDate: String, completion: @escaping (FetchingChatModel?, Int?) -> Void) {
        ChatAPI.fetchChat(from: from, lastchatDate: lastchatDate) { chat, statusCode, error in
            completion(chat, statusCode)
        }
    }
}
