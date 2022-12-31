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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        return formatter.string(from: self)
    }
    
    func getMonthDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "M월 dd일 E요일"
        return formatter.string(from: self)
    }
    
    //MARK: - 채팅 날짜
    //MARK: - 오늘/ 과거날짜
    func getChatDateFormat(memodate: Date) -> String {
        if memodate.isInSameDay(as: Date()) {
            return getTodayDate()
        } else {
            return otherDate(memodate: memodate)
        }
    }
    
    //MARK: - 오늘
    func getTodayDate() -> String {
        return getFormatter(format: "HH:mm").string(from: Date())
    }
    
    //MARK: - 과거
    func otherDate(memodate: Date) -> String {
        return getFormatter(format: "MM/dd a HH:mm").string(from: memodate)
    }
    
    func getFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter
    }
}

extension Date {
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
}
