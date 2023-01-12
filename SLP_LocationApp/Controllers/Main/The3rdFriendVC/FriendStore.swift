//
//  FriendStore.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/12.
//

import Foundation
import RxSwift

protocol FriendFetchable {
    func fetchFriends() -> Observable<[Friend]>
}

class FriendStore: FriendFetchable {
    func fetchFriends() -> Observable<[Friend]> {
        struct Response: Decodable {
            let friends: [Friend]
        }
        
        return HomeAPI.
    }
}
