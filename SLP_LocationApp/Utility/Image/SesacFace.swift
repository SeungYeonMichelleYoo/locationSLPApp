//
//  SesacFace.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/07.
//

import UIKit

class SesacFace {
    static func image(level: Int) -> UIImage {
        return UIImage(named: "sesac_face_\(level + 1)")!
    }
}
