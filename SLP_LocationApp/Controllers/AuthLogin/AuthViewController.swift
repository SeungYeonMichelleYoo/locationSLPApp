//
//  AuthViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class AuthViewController: BaseViewController, UITextFieldDelegate {
        
    var mainView = AuthView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.delegate = self
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }
    @objc func sendBtnClicked() {
        mainView.textField.resignFirstResponder()
        
        if let text = mainView.textField.text, !text.isEmpty {
            let number = "+1\(text)"
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    let vc = SMSCodeViewController()
                    self?.transition(vc, transitionStyle: .presentFullScreen)
                }
            }
        }
    }
}

