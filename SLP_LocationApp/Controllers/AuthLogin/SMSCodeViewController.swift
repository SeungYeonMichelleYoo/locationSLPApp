//
//  SMSCodeViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit

final class SMSCodeViewController: BaseViewController, UITextFieldDelegate {
    
    var mainView = SMSCodeView()
    
    var viewModel = UserViewModel()
    
    var phoneNumber = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.textField.delegate = self
        mainView.startBtn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
        
        mainView.textField.textContentType = .oneTimeCode //SMSCode 문자 내용 자동완성 붙여넣기
        
        mainView.textField.addTarget(self, action: #selector(SMSCodeViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if mainView.textField.text!.count == 6 {
            mainView.startBtn.fill()
        } else {
            mainView.startBtn.disable()
        }
    }
    
    @objc func startBtnClicked() {
        mainView.textField.resignFirstResponder()
        
        if let text = mainView.textField.text, !text.isEmpty {
            let code = text
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    self!.viewModel.refreshIDToken { isSuccess in
                        if isSuccess! {
                            self!.userCheckRecursion()
                        } else {
                            self!.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                        }
                    }
                }
            }
        }
    }
    
    func userCheckRecursion() {
        self.viewModel.userCheckVM { user, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                UserDefaults.standard.set(user!.uid, forKey: "myUID")
                UserDefaults.standard.set(self.phoneNumber, forKey: "phoneNumber")
                print("서버 가입된 회원 : 메인으로 이동")
                let vc = TabBarViewController()
                vc.setNick(nick: user!.nick)
                vc.setSesac(sesac: user!.sesac)
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            case APIStatusCode.unAuthorized.rawValue, APIStatusCode.forbiddenNickname.rawValue:
                print("미가입 회원. 닉네임화면으로 이동 / 또는 금지된 닉네임 사용한 자")
                UserDefaults.standard.set(self.phoneNumber, forKey: "phoneNumber")
                let vc = NicknameViewController()
                vc.FCMtoken = UserDefaults.standard.string(forKey: "FCMtoken")!
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                self.viewModel.refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.userCheckRecursion()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
}
