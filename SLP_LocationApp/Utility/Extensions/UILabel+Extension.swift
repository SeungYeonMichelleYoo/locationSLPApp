//
//  UILabel+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/06.
//
import UIKit

class ChatPaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
}

