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
    static let BASEURL: String = "http://api.sesac.co.kr:1210"
    
    static func userCheck(idToken: String, completion: @escaping (User?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user"
        KeychainSwift().set(idToken, forKey: "idToken")
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode
            print(response)
            print("statusCode: \(statusCode)")
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    static func signUp(idToken: String, phoneNumber: String, FCMtoken: String, nick: String, birth: Date, email: String, gender: Int, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user"
        KeychainSwift().set(idToken, forKey: "idToken")
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        let params: Parameters = ["phoneNumber": phoneNumber, "FCMtoken": FCMtoken, "nick": nick, "birth": birth.toString(), "email": email, "gender": gender]
        print(params)
        AF.request(url, method: .post, parameters: params, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode
            print(response)
            print("statusCode: \(statusCode)")
            switch response.result {
            case .success(let value): completion(statusCode, nil)
            case .failure(let error): completion(statusCode, error)
            }
        }
    }
    
    static func withdraw(idToken: String, completion: @escaping (User?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user/withdraw"
        KeychainSwift().set(idToken, forKey: "idToken")
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode
            print(response)
            print("statusCode: \(statusCode)")
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    private init() {
        
    }
}
