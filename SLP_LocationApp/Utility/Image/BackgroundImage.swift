//
//  BackgroundImage.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/09.
//
import UIKit

class BackgroundImage {
    static func image(level: Int) -> UIImage {
        return UIImage(named: "sesac_background_\(level + 1)")!
    }
}
