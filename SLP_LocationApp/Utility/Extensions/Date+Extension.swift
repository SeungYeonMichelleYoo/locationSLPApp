//
//  Date+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/13.
//

import Foundation

extension Date {
    func getYear() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return Int(formatter.string(from: self))!
    }
    
    func getMonth() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return Int(formatter.string(from: self))!
    }
    
    func getDay() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: self))!
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
    
    func getMonthDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일 E요일"
        return formatter.string(from: self)
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
