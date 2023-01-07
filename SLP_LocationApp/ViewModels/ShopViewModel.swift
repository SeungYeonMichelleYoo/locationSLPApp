//
//  ShopViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/06.
//
import Foundation
import KeychainSwift
import FirebaseAuth

class ShopViewModel {
    
    //보유 상품 조회
    func checkPurchaseStateVM(completion: @escaping (User?, Int?) -> Void) {
        
        ShopAPI.checkPurchaseState() { user, statusCode, error in
            completion(user, statusCode)
        }
    }
    
    //저장 버튼 클릭시
    func updateWhenSaveVM(sesac: Int, background: Int, completion: @escaping (Int?) -> Void) {
        
        ShopAPI.updateWhenSave(sesac: sesac, background: background) { statusCode, error in
            completion(statusCode)
        }
    }
  
    //상품 구매
    func purchaseRequestVM(receipt: String, product: String, completion: @escaping (Int?) -> Void) {
        
        ShopAPI.purchaseRequest(receipt: receipt, product: product) { statusCode, error in
            completion(statusCode)
        }
    }    
}
