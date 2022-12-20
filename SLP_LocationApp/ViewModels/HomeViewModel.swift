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
    
    //스터디 입력화면 - 새싹찾기 버튼 클릭시 호출
    func searchForStudyVM(lat: Double, long: Double, studylist: [String], completion: @escaping (MyQueue?, Int?) -> Void) {
        
        HomeAPI.searchForStudy(lat: lat, long: long, studylist: studylist) { myQueue, statusCode, error in
            completion(myQueue, statusCode)
        }
    }
    
    //스터디 찾기 중단
    func stopStudyVM(completion: @escaping (MyQueue?, Int?) -> Void) {
        
        HomeAPI.stopStudy(completion: { myQueue, statusCode, error in
            completion(myQueue, statusCode)
        })
    }
    
    //스터디 요청
    func studyrequestVM(otheruid: String, completion: @escaping (Int?) -> Void) {
        
        HomeAPI.requestStudy(otheruid: otheruid) { statusCode, error in
            completion(statusCode)
        }
    }
    
    //스터디 수락
    func studyacceptVM(otheruid: String, completion: @escaping (Int?) -> Void) {
        
        HomeAPI.studyAccept(otheruid: otheruid) { statusCode, error in
            completion(statusCode)
        }
    }
}
