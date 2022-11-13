//
//  UIButton+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit

extension UIButton {
    func fill() {
        backgroundColor = Constants.BaseColor.green
    }
    
    func disable() {
        backgroundColor = Constants.BaseColor.gray6
    }
}
