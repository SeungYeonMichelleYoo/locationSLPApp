//
//  SMSCodeViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit
import SnapKit
import FirebaseAuth

class SMSCodeViewController: BaseViewController, UITextFieldDelegate {
    
    var mainView = SMSCodeView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainView.textField.delegate = self
        mainView.startBtn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
    }
    @objc func startBtnClicked() {
        mainView.textField.resignFirstResponder()
        
        if let text = mainView.textField.text, !text.isEmpty {
            let code = text
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    let vc = NicknameViewController()
                    self?.transition(vc, transitionStyle: .push)
//                    if Auth.auth().currentUser == nil {
//                        let vc = NicknameViewController()
//                        self?.transition(vc, transitionStyle: .presentFullScreen)
//                    } else {
//                        let vc = MainMapViewController()
//                        self?.transition(vc, transitionStyle: .presentFullScreen)
//                    } //결과값: 메인으로 자꾸 가버림. 서버랑 연동해서 회원가입 안되어있을 경우 nickname vc 로 가야함.
                }
            }
        }
    }
}
