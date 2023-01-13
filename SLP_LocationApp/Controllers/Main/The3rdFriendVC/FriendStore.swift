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
        
        return ChatAPI.fetchAllFriendsRx()
            .map { data in
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1)
                }
                return response.friends
            }
    }
}
