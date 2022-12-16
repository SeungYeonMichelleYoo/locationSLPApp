//
//  UIImage+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/08.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = Constants.BaseColor.gray2.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    func makeRoundedRadius() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.cornerRadius = 8
        layer.borderColor = Constants.BaseColor.gray2.cgColor
        clipsToBounds = true
    }
}
