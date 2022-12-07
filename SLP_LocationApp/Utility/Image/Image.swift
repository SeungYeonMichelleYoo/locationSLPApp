//
//  SesacFace.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/07.
//

import UIKit

enum Image {

    enum SesacFace: Int {
        case sesacFace1 = 1
        case sesacFace2
        case sesacFace3
        case sesacFace4
        case sesacFace5
        
        var image: UIImage? {
            return UIImage(named: "sesac_face_\(self.rawValue)")
        }
    }
    
}
