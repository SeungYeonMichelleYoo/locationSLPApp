//
//  User.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import Foundation

struct User: Decodable {
    let uid: String //회원 id
    let phoneNumber: String
    let email: String
    let FCMtoken: String
    let nick: String
    let birth: Date?
    let gender: Int
    let study: String
    let comment: [String] //리뷰하기에서 받은 후기 배열
    let reputation: [Int] //리뷰하기에서 받은 평가항목 배열
    let sesac: Int //현재 선택한 새싹 이미지
    let sesacCollection: [Int] //보유하고 있는 새싹 배열
    let background: Int //현재 선택한 배경 이미지
    let backgroundCollection: [Int]
    let purchaseToken: [String]
    let transactionId: [String]
    let reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty: Int
    let dodgeNum: Int
    let ageMin: Int
    let ageMax: Int
    let searchable: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case phoneNumber
        case email
        case FCMtoken
        case nick
        case birth
        case gender
        case study
        case comment
        case reputation
        case sesac
        case sesacCollection
        case background
        case backgroundCollection
        case purchaseToken
        case transactionId
        case reviewedBefore
        case reportedNum
        case reportedUser
        case dodgepenalty
        case dodgeNum
        case ageMin
        case ageMax
        case searchable
        case createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        FCMtoken = try container.decode(String.self, forKey: .FCMtoken)
        nick = try container.decode(String.self, forKey: .nick)
        birth = try container.decode(Date.self, forKey: .birth)
        gender = try container.decode(Int.self, forKey: .gender)
        study = try container.decode(String.self, forKey: .study)
        comment = try container.decode([String].self, forKey: .comment)
        reputation = try container.decode([Int].self, forKey: .reputation)
        sesac = try container.decode(Int.self, forKey: .sesac)
        sesacCollection = try container.decode([Int].self, forKey: .sesacCollection)
        background = try container.decode(Int.self, forKey: .background)
        backgroundCollection = try container.decode([Int].self, forKey: .backgroundCollection)
        purchaseToken = try container.decode([String].self, forKey: .purchaseToken)
        transactionId = try container.decode([String].self, forKey: .transactionId)
        reviewedBefore = try container.decode([String].self, forKey: .reviewedBefore)
        reportedNum = try container.decode(Int.self, forKey: .reportedNum)
        reportedUser = try container.decode([String].self, forKey: .reportedUser)
        dodgepenalty = try container.decode(Int.self, forKey: .dodgepenalty)
        dodgeNum = try container.decode(Int.self, forKey: .dodgeNum)
        ageMin = try container.decode(Int.self, forKey: .ageMin)
        ageMax = try container.decode(Int.self, forKey: .ageMax)
        searchable = try container.decode(Int.self, forKey: .searchable)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
       
}
