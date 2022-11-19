//
//  Font+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/09.
//
import UIKit
//사용:
//UIFont.Font.font(.Title5_M12)

extension UIFont {
    enum WeightFont: String {
        case Medium = "NotoSansKR-Medium"
        case Regular = "NotoSansKR-Regular"

        func of(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            return WeightFont.Medium.of(size: size)
        }

        static func regular(size: CGFloat) -> UIFont {
            return WeightFont.Regular.of(size: size)
        }
    }
    
    enum Font: String {
        case Display1_R20
        case Title1_M16
        case Title2_R16
        case Title3_M14
        case Title4_R14
        case Title5_M12
        case Title6_R12
        case Body1_M16
        case Body2_R16
        case Body3_R14
        case Body4_R12
        case caption_R10
    }
    
    static func font(_ type: Font) -> UIFont {
        let rightSide = type.rawValue.split(separator: "_")[1] //R12
        let weight = String(rightSide.prefix(1)) //R
        let startIndex = rightSide.index(rightSide.startIndex, offsetBy: 1) //1
        let size = CGFloat(NSString(string: String(rightSide[startIndex...])).floatValue)
        if weight == "M" {
            return WeightFont.medium(size: size)
        } else {
            return WeightFont.regular(size: size)
        }
    }
}
