//
//  ViewFriend.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/13.
//

import Foundation

struct ViewFriend {
    var image: Int
    var matchedNick: String
    var study: String
    var chat: String
    var date: String
    
    init(image: Int, matchedNick: String, study: String, chat: String, date: String) {
        self.image = image
        self.matchedNick = matchedNick
        self.study = study
        self.chat = chat
        self.date = date
    }
}
