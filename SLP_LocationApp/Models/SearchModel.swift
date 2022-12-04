//
//  SearchModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/30.
//

import Foundation

struct SearchModel: Decodable {
    var fromQueueDB: [OpponentModel]
    var fromQueueDBRequested: [OpponentModel]
    var fromRecommend: [String]
}

struct OpponentModel: Decodable {
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
    var expanded: Bool
    
    enum CodingKeys: String, CodingKey {
        case studylist
        case reviews
        case reputation
        case uid
        case nick
        case gender
        case type
        case sesac
        case background
        case lat
        case long
        case expanded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        studylist = try container.decode([String].self, forKey: .studylist)
        reviews = try container.decode([String].self, forKey: .reviews)
        reputation = try container.decode([Int].self, forKey: .reputation)
        uid = try container.decode(String.self, forKey: .uid)
        nick = try container.decode(String.self, forKey: .nick)
        gender = try container.decode(Int.self, forKey: .gender)
        type = try container.decode(Int.self, forKey: .type)
        sesac = try container.decode(Int.self, forKey: .sesac)
        background = try container.decode(Int.self, forKey: .background)
        lat = try container.decode(Double.self, forKey: .lat)
        long = try container.decode(Double.self, forKey: .long)
        expanded = false
    }
}
