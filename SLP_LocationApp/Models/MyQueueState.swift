//
//  MyQueueState.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//

import Foundation

struct MyQueueState: Codable {
    var dodged: Int
    var matched: Int
    var reviewed: Int
    var matchedNick: String?
    var matchedUid: String?
}
