//
//  HomeViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import Foundation
import KeychainSwift
import FirebaseAuth

class HomeViewModel {
    
    //현재 매칭 상태 확인
    func checkMatchStateVM(completion: @escaping (Int?) -> Void) {
        
        HomeAPI.checkMatchState(completion: { statusCode, error in
            completion(statusCode)
        })
    }
}
