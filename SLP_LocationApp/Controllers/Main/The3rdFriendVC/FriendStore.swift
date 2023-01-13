//
//  FriendStore.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/12.
//

import Foundation
import RxSwift

protocol FriendFetchable {
    func fetchFriends(from: String, lastChatDate: String) -> Observable<[Friend]>
}

class FriendStore: FriendFetchable {
    func fetchFriends(from: String, lastChatDate: String) -> Observable<[Friend]> {
        struct ResponseRx: Decodable {
            let friends: [Friend]
        }
        
        return ChatAPI.fetchAllFriendsRx(from: from, lastChatDate: lastChatDate)
            .map { data in
                guard let response = try? JSONDecoder().decode(ResponseRx.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1)
                }
                return response.friends
            }
    }
}
