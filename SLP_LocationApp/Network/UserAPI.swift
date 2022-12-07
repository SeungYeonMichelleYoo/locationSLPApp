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
    
    //로그인
    static func userCheck(completion: @escaping (User?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            let statusCode = response.response?.statusCode
            print(response)
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    //회원가입
    static func signUp(phoneNumber: String, FCMtoken: String, nick: String, birth: Date, email: String, gender: Int, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        let params: Parameters = ["phoneNumber": phoneNumber, "FCMtoken": FCMtoken, "nick": nick, "birth": birth.toString(), "email": email, "gender": gender]
        print(params)
        AF.request(url, method: .post, parameters: params, headers: headers).responseDecodable(of: User.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
    //회원탈퇴
    static func withdraw(completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user/withdraw"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .post, headers: headers).response { response in
            let statusCode = response.response?.statusCode

            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }

    //내 정보 관리 수정
    static func mypageUpdate(dict: Dictionary<String, String>, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user/mypage"
        
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = dict
        
        AF.request(url, method: .put, parameters: params, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
           
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
    private init() {
        
    }
}
