//
//  MyQueue.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/17.
//
import Foundation

struct MyQueue: Codable {
    var long: Double
    var lat: Double
    var studylist: [String]
    
//    enum CodingKeys: String, CodingKey {
//        case long
//        case lat
//        case studylist
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        long = try container.decode(Double.self, forKey: .long)
//        lat = try container.decode(Double.self, forKey: .lat)
//        studylist = try container.decode([String].self, forKey: .studylist)
//    }
}
