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
            print(response.value!)
            switch response.result {
            case .success(let value): completion(response.value!, statusCode, nil)
                return
            case .failure(let error): completion(nil, statusCode, error)
                return
            }
        }
    }
    
}
