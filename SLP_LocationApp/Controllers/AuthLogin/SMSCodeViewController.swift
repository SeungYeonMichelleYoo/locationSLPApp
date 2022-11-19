//
//  SMSCodeViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit

class SMSCodeViewController: BaseViewController, UITextFieldDelegate {
    
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
    }
        
    @objc func startBtnClicked() {
        mainView.textField.resignFirstResponder()
        
        if let text = mainView.textField.text, !text.isEmpty {
            let code = text
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
                print("smscode 클로저 진입")
                guard success else { return }
                DispatchQueue.main.async {
                    print("idtokenGetTest하기 전")
                    self!.viewModel.userCheckVM { user, statusCode in
                        switch statusCode {
                        case 200:
                            UserDefaults.standard.set(self?.phoneNumber, forKey: "phoneNumber")
                            print("서버 가입된 회원 : 메인으로 이동")
                            let vc = MainMapViewController()
                            vc.FCMtoken = user!.FCMtoken
                            self!.transition(vc, transitionStyle: .presentFullScreen)
                        case 406, 202: print("미가입 회원. 닉네임화면으로 이동 / 또는 금지된 닉네임 사용한 자")
                            UserDefaults.standard.set(self?.phoneNumber, forKey: "phoneNumber")
                            let vc = NicknameViewController()
                            vc.FCMtoken = UserDefaults.standard.string(forKey: "FCMtoken")!
                            self!.transition(vc, transitionStyle: .presentFullScreen)
                        case 401: print("firebase 인증 오류")
                            self!.showToast(message: "휴대폰 인증을 다시 해주세요.")
                        case 500, 501: print("서버 점검중입니다. 관리자에게 문의해주세요.")
                            self!.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                        default: self!.showToast(message: "네트워크 연결을 확인해주세요.")
                        }
                    }
                    print("idtokenGetTest완료")
                }
            }
        }
    }
}
