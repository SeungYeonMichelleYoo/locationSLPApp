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
    
    func idtokenGetTest(completion: @escaping (Int?) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            // Handle error
              completion(-1) //idToken 값 없음
            return;
          }
            print("idToken: \(idToken)")
          // Send token to your backend via HTTPS
            UserAPI.userCheck(idToken: idToken!) { statusCode, error in
                completion(statusCode)
            }
        }
    }
    
}
