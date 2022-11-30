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
    func checkMatchStateVM(completion: @escaping (MyQueueState?, Int?) -> Void) {
        
        HomeAPI.checkMatchState(completion: { myQueueState, statusCode, error in
            completion(myQueueState, statusCode)
        })
    }
    
    //주변 새싹찾기 서버통신
    func nearbySearchVM(lat: Double, long: Double, completion: @escaping (SearchModel?, Int?) -> Void) {
        
        HomeAPI.nearbySearch(lat: lat, long: long) { searchModel, statusCode, error in
            completion(searchModel, statusCode)
        }
    }
}
