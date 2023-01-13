//
//  ChatAPI.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/30.
//

import Foundation
import Alamofire
import KeychainSwift
import RxSwift

class ChatAPI {
    static let BASEURL: String = "http://api.sesac.co.kr:1210"
    
    //채팅 보내기
    static func sendChat(chat: String, to: String, completion: @escaping (Chat?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/chat/\(to)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["chat": chat]
        
        AF.request(url, method: .post, parameters: params, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            do {
                let chat = try decoder.decode(Chat.self, from: response.data!)
                switch response.result {
                case .success(_): completion(chat, statusCode, nil)
                    return
                case .failure(let error): completion(nil, statusCode, error)
                    return
                }
            } catch  let error as NSError {
                completion(nil, statusCode, error)
            }
        }
    }
    
    //채팅 받아오기
    static func fetchChat(from: String, lastchatDate: String, completion: @escaping (FetchingChatModel?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/chat/\(from)?lastchatDate=\(lastchatDate)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            print(response.data!)
            do {
                let fetchingChatModel = try decoder.decode(FetchingChatModel.self, from: response.data!)
                
                switch response.result {
                case .success(_): completion(fetchingChatModel, statusCode, nil)
                    return
                case .failure(let error): completion(nil, statusCode, error)
                    return
                }
            } catch let error as NSError {
                completion(nil, statusCode, error)
            }
        }
    }
    
    //채팅 받아오기
    static func fetchChatRx(from: String, lastchatDate: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(BASEURL)/v1/chat/\(from)?lastchatDate=\(lastchatDate)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            print(response.data!)
            if let err = response.error {
                completion(.failure(err))
                return
            }
            guard let data = response.data else {
                let httpResponse = response.response!
                completion(.failure(NSError(domain: "no data", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            completion(.success(data))
        }
    }
}

extension ChatAPI {
    static func fetchAllFriendsRx(from: String, lastChatDate: String) -> Observable<Data> {
        return Observable.create { emitter in
            fetchChatRx(from: from, lastchatDate: lastChatDate) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
