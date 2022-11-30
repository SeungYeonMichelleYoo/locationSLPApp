//
//  SearchModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/30.
//

import Foundation

struct SearchModel: Codable {
    var fromQueueDB: [OpponentModel]
    var fromQueueDBRequested: [OpponentModel]
    var fromRecommend: [String]
}

struct OpponentModel: Codable {
    var studylist: [String]
    var reviews: [String]
    var reputation: [Int]
    var uid: String
    var nick: String
    var gender: Int
    var type: Int
    var sesac: Int
    var background: Int
    var lat: Double
    var long: Double
}
