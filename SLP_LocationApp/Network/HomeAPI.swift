//
//  HomeAPI.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import Foundation
import Alamofire
import KeychainSwift

class HomeAPI {
    static let BASEURL: String = "http://api.sesac.co.kr:1210"
    
    //매칭상태확인
    static func checkMatchState(completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/myQueueState"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
}
