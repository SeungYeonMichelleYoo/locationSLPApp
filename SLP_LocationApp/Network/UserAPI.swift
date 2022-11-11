//
//  UserAPI.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import Foundation
import KeychainSwift
import Alamofire

class UserAPI {
    
    static func userCheck(idToken: String, completion: @escaping (Int?, Error?) -> Void) {
        let url = "http://api.sesac.co.kr:1207/v1/user"
        KeychainSwift().set(idToken, forKey: "idToken")
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode
            print(response)
            print("statusCode: \(statusCode)")
            switch response.result {
            case .success(let value): completion(statusCode, nil)
            case .failure(let error): completion(statusCode, error)
            }
        }
    }
    
    private init() {
        
    }
    
}

