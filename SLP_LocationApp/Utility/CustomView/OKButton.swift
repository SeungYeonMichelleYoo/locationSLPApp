//
//  OKButton.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//

import UIKit

class OKButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        tintColor = UIColor.white
        backgroundColor = Constants.BaseColor.green
    }
}
