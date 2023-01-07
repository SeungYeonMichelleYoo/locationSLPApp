//
//  Int+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/06.
//

import Foundation
extension Int {
    func numberFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
