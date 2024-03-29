//
//  UITextField+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit

extension UITextField {
  func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
