//
//  NicknameViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit
import SnapKit
import Toast
import IQKeyboardManagerSwift

class NicknameViewController: BaseViewController, UITextFieldDelegate {
        
    var mainView = NicknameView()
    
    var phoneNumber = ""
    var FCMtoken = ""

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.becomeFirstResponder()
        mainView.textField.delegate = self
        mainView.textField.addTarget(self, action: #selector(NicknameViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
        
        phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")!
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if mainView.textField.text!.count >= 1 {
            mainView.sendBtn.fill()
        } else {
            mainView.sendBtn.disable()
        }
      }
    
    @objc func sendBtnClicked() {
        if mainView.textField.text!.count > 10 {
            showToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요.")
        } else {
            let vc = BirthViewController()
            vc.nickname = mainView.textField.text!
            vc.FCMtoken = FCMtoken
            self.transition(vc, transitionStyle: .push)
        }
//        회원가입 플로우 실패
//        showToast(message: "해당 닉네임은 사용할 수 없습니다.")
    }
    
    //10자 이내 글자수 제한 및 백스페이스 감지
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        guard textField.text!.count < 10 else { return false }
        return true
    }
}
