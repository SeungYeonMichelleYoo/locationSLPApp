//
//  ShopViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/06.
//
import Foundation
import KeychainSwift
import FirebaseAuth

class ShopViewModel {
    
    //보유 상품 조회
    func detectProductsVM(chat: String, to: String, completion: @escaping (Chat?, Int?) -> Void) {
        ChatAPI.sendChat(chat: chat, to: to) { chat, statusCode, error in
            completion(chat, statusCode)
        }
    }
}
