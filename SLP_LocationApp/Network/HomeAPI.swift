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
    static func checkMatchState(completion: @escaping (MyQueueState?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/myQueueState"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: MyQueueState.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    
    //주변 새싹찾기 서버통신
    static func nearbySearch(lat: Double, long: Double, completion: @escaping (SearchModel?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/search"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["lat": lat, "long": long]
        AF.request(url, method: .post, parameters: params, headers: headers).responseDecodable(of: SearchModel.self) { response in
            let statusCode = response.response?.statusCode
            print("nearbysearch api called")
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    //SearchVC - 스터디 입력화면 - 새싹찾기 버튼 클릭시 호출
    static func searchForStudy(lat: Double, long: Double, studylist: [String], completion: @escaping (MyQueue?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        var params: Parameters
        if studylist.count == 0 {
            params = ["lat": lat, "long": long, "studylist": "anything"]
        } else {
            params = ["lat": lat, "long": long, "studylist": studylist.joined(separator: ",")]
        }
        AF.request(url, method: .post, parameters: params, headers: headers).responseDecodable(of: MyQueue.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    //스터디 찾기 중단
    static func stopStudy(completion: @escaping (MyQueue?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: MyQueue.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
    //스터디 요청
    static func requestStudy(otheruid: String, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/studyrequest"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["otheruid": otheruid]
        
        AF.request(url, method: .post, parameters: params, headers: headers).response { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
    //스터디 수락
    static func studyAccept(otheruid: String, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/studyaccept"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["otheruid": otheruid]
        
        AF.request(url, method: .post, parameters: params, headers: headers).response { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
    //스터디 취소
    static func dodgeStudy(otheruid: String, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/dodge"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["otheruid": otheruid]
        
        AF.request(url, method: .post, parameters: params, headers: headers).response { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
    
    //리뷰 보내기
    static func sendReview(otheruid: String, comment: String, reputation: [Int], completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/queue/rate/\(otheruid)"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["otheruid": otheruid, "comment": comment, "reputation": reputation]
        AF.request(url, method: .post, parameters: params, headers: headers).response { response in
            let statusCode = response.response?.statusCode
            print("sendReview api called")
            print(response.value)
            print(response)
            switch response.result {
            case .success(let value): completion(statusCode, nil)
                return
            case .failure(let error): completion(statusCode, error)
                return
            }
        }
    }
}
