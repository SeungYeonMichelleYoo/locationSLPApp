//
//  UIButton+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit

extension UIButton {
    func fillBtn() {
        layer.cornerRadius = 8
        clipsToBounds = true
        tintColor = UIColor.white
        backgroundColor = Constants.BaseColor.green
    }
    
    func disableBtn() {
        layer.cornerRadius = 8
        clipsToBounds = true
        tintColor = UIColor.white
        backgroundColor = Constants.BaseColor.gray6
    }
}
