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
    
    func idtokenGetTest() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            // Handle error
              print("error")
            return;
          }
            print("idToken: \(idToken)")
          // Send token to your backend via HTTPS
            UserAPI.userCheck(idToken: idToken!) { statusCode, error in
                switch statusCode {
                case 200:
                    print("서버 가입된 회원 : 메인으로 이동")
                    let vc = MainMapViewController()
                    self.transition(vc, transitionStyle: .presentFullScreen)
                case 406, 202: print("미가입 회원. 닉네임화면으로 이동 / 또는 금지된 닉네임 사용한 자")
                    let vc = NicknameViewController()
                    self.transition(vc, transitionStyle: .push)
                case 401: print("firebase 인증 오류")
                    self.showToast(message: "휴대폰 인증을 다시 해주세요.")
                case 500, 501: print("서버 점검중입니다. 관리자에게 문의해주세요.")
                    self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                default: ""
                }
            }
        }
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
                    self!.idtokenGetTest()
                    print("idtokenGetTest완료")
                }
            }
        }
    }
}
