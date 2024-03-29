//
//  String+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/09.
//

import Foundation
extension String {
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        
        return CGFloat(doubleValue)
    }
    
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

