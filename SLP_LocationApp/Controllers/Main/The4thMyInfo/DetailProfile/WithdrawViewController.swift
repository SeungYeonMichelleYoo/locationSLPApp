//
//  WithdrawViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/21.
//

import UIKit

final class WithdrawViewController: BaseViewController {
    
    var mainView = WithdrawView()
    
    var viewModel = UserViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
        
        mainView.cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        mainView.okBtn.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
    }
    
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
    }
    
    @objc func cancelBtnClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func okBtnClicked() {
        withdraw()
    }
}

extension WithdrawViewController {
    func withdraw() {
        viewModel.withdrawVM { statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.removeObject(forKey: "idToken")
                self.showToast(message: "회원 탈퇴가 완료되었습니다.")
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case 401:
                self.showToast(message: "휴대폰 인증을 다시 해주세요.")
            case 406: //이미 탈퇴 처리된 회원, 미가입 회원
                self.showToast(message: "이미 탈퇴한 회원이거나 미가입 회원이십니다. 첫 화면으로 돌아갑니다.")
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case 500:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
            case 501:
                print("Client Error. API요청시 header, requestbody 값 빠뜨리지 않고 전송했는지 확인")
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
            default:
                break
            }
        }
    }
}
