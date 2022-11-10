//
//  NicknameViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit
import SnapKit
import Toast

class NicknameViewController: BaseViewController {
        
    var mainView = NicknameView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.becomeFirstResponder()
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }
    @objc func sendBtnClicked() {
        
    }
}
