//
//  ChatAPI.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/30.
//

import Foundation
import Alamofire
import KeychainSwift

class ChatAPI {
    static let BASEURL: String = "http://api.sesac.co.kr:1210"
    
    //채팅 보내기
    static func sendChat(chat: String, to: String, completion: @escaping (Chat?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/chat/\(to)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["chat": chat]
        
        AF.request(url, method: .post, parameters: params, headers: headers).responseDecodable(of: Chat.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    //채팅 받아오기
    static func fetchChat(from: String, lastchatDate: String, completion: @escaping (FetchingChatModel?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/chat/\(from)?lastchatDate=\(lastchatDate)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: FetchingChatModel.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
}
