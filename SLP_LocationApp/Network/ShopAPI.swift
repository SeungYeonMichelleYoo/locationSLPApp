//
//  ShopAPI.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/06.
//
import Foundation
import Alamofire
import KeychainSwift

class ShopAPI {
    static let BASEURL: String = "http://api.sesac.co.kr:1210"
    
    //상품 보유 O/X 확인
    static func checkPurchaseState(completion: @escaping (User?, Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
                
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            do {
                let user = try decoder.decode(User.self, from: response.data!)
                
                switch response.result {
                case .success(_):
                    completion(user, statusCode, nil)
                    return
                case .failure(let error): completion(nil, statusCode, error)
                    return
                }
            } catch let error as NSError {
                completion(nil, statusCode, error)
            }
        }
    }
        
    //유저 프로필 새싹, 배경화면 업데이트(새싹 샵에서 새싹과 배경 변경 후 저장 시 호출)
    static func updateWhenSave(sesac: Int, background: Int, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user/shop/item"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["sesac": sesac, "background": background]
        
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
    
    //상품 구매 (상품 보유가 아닌 경우)
    static func purchaseRequest(receipt: String, product: String, completion: @escaping (Int?, Error?) -> Void) {
        let url = "\(BASEURL)/v1/user/shop/ios"
        let headers: HTTPHeaders = ["idtoken" : KeychainSwift().get("idToken")!]
        let params: Parameters = ["receipt": receipt, "product": product]
        
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
}
