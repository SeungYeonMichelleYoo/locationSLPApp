//
//  UserViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/12.
//

import Foundation
import KeychainSwift
import FirebaseAuth

class UserViewModel {
    
    // function:  idtokenGetTest
    // return: (Closure)
    //   Int:
    //       nil: Network error
    //        -1: no idtoken
    //       200: 파이어베이스 O, 서버 O
    //   406,202: 파이어베이스 O, 서버 X
    //       401: 파이어베이스 X
    //   500,501: server error
    
    
    func refreshIDToken(completion: @escaping (String?) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                UserDefaults.standard.removeObject(forKey: "idToken")
                completion(nil) //네트워크 오류(idToken값이 없을 수가 없어)
                return;
            }
            print("idToken: \(idToken)")
            UserDefaults.standard.set(idToken, forKey: "idToken")
            // Send token to your backend via HTTPS
            completion(idToken)
        }
    }
    
    //로그인
    func userCheckVM(completion: @escaping (User?, Int?) -> Void) {
        refreshIDToken { idToken in
            switch idToken {
            case nil:
                completion(nil, nil)
            default:
                UserAPI.userCheck(idToken: UserDefaults.standard.string(forKey: "idToken")!) { user, statusCode, error in
                    completion(user, statusCode)
                }
            }
        }
    }
    
    //회원가입
    func signUpVM(phoneNumber: String, FCMtoken: String, nick: String, birth: Date, email: String, gender: Int, completion: @escaping (Int?) -> Void) {
        refreshIDToken { idToken in
            switch idToken {
            case nil:
                completion(nil)
            default:
                UserAPI.signUp(idToken: UserDefaults.standard.string(forKey: "idToken")!, phoneNumber: phoneNumber, FCMtoken: FCMtoken, nick: nick, birth: birth, email: email, gender: gender) { statusCode, error in
                    completion(statusCode)
                }
            }
        }
    }
    
    //탈퇴
    func withdrawVM(completion: @escaping (User?, Int?) -> Void) {
        refreshIDToken { idToken in
            switch idToken {
            case nil:
                completion(nil, nil)
            default:
                UserAPI.userCheck(idToken: UserDefaults.standard.string(forKey: "idToken")!) { user, statusCode, error in
                    completion(user, statusCode)
                }
            }
        }
    }
}
