//
//  GenderViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class GenderViewController: BaseViewController {
    
    var mainView = GenderView()
    
    var nickname = ""
    var birth: Date = Date()
    var emailAddress = ""
    var gender: Int = 0
    var phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
    var FCMtoken = UserDefaults.standard.string(forKey: "FCMtoken")
    
    var viewModel = UserViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        
        mainView.maleBtn.addTarget(self, action: #selector(maleBtnClicked), for: .touchUpInside)
        mainView.femaleBtn.addTarget(self, action: #selector(femaleBtnClicked), for: .touchUpInside)
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func maleBtnClicked() {
        mainView.femaleBtn.inactive()
        mainView.maleBtn.backgroundColor = Constants.BaseColor.whitegreen
        mainView.maleBtn.layer.cornerRadius = 8
        mainView.sendBtn.fill()
        gender = 1
    }
    @objc func femaleBtnClicked() {
        mainView.maleBtn.inactive()
        mainView.femaleBtn.backgroundColor = Constants.BaseColor.whitegreen
        mainView.femaleBtn.layer.cornerRadius = 8
        mainView.sendBtn.fill()
        gender = 0
    }
    @objc func sendBtnClicked() {
        signUp()
        let vc = MainMapViewController()
        vc.gender = gender
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    func signUp() {
        viewModel.signUpVM(phoneNumber: UserDefaults.standard.string(forKey: "phoneNumber")!.replacingOccurrences(of: "+820", with: "+82").replacingOccurrences(of: "-", with: ""), FCMtoken: UserDefaults.standard.string(forKey: "FCMtoken")!, nick: nickname, birth: birth, email: emailAddress, gender: gender) { statusCode in
            switch statusCode {
            case 401:
                self.showToast(message: "휴대폰 인증을 다시 해주세요.")
            case 500:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
            case 501:
                print("서버 String으로 받아야 함")
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
            default:
                break
            }
            
            switch statusCode {
            case 200:
                let vc = MainMapViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case 406, 202:
                let vc = NicknameViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case -1, 401, nil:
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            default:
                break
            }
        }
    }
}
