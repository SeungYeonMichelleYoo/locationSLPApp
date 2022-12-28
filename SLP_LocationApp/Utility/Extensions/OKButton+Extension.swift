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
        isUserInteractionEnabled = true
    }
    
    func disable() {
        backgroundColor = Constants.BaseColor.gray6
        isUserInteractionEnabled = false
    }
    
    func inactive() {
        backgroundColor = UIColor.white
        layer.borderColor = Constants.BaseColor.gray4.cgColor
        layer.borderWidth = 1.0
    }
    
    func cancel() {
        backgroundColor = Constants.BaseColor.gray2
    }
}
