//
//  NoNetworkViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit
import SnapKit

class NoNetworkViewController: BaseViewController {
    
    var mainView = NoNetworkView()
    
    var viewModel = UserViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white

        //파이어베이스 인증 o/x : 닉네임,홈화면 / 온보딩
        //서버 등록 o/x : 홈화면 / 닉네임
        //401은 여기서 나올 일이 없음(왜냐하면 userCheckVM에서 idToken을 무조건 갱신해오기 때문)
        print(Date().toString())
        if UserDefaults.standard.string(forKey: "idToken") == nil {
            let vc = OnboardingViewController()
            self.transition(vc, transitionStyle: .presentFullScreen)
        } else {
            viewModel.userCheckVM { user, statusCode in
                print(statusCode)
                switch statusCode {
                case 500, 501:
                    self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                case nil:
                    self.showToast(message: "네트워크 연결을 확인해주세요.")
                default:
                    break
                }

                switch statusCode {
                case 200:
                    let vc = TabBarViewController()
                    self.transition(vc, transitionStyle: .presentFullScreen)
                case 406, 202:
                    let vc = NicknameViewController()
                    self.transition(vc, transitionStyle: .push)
                case -1, nil:
                    let vc = OnboardingViewController()
                    self.transition(vc, transitionStyle: .presentFullScreen)
                default:
                    break
                }
            }
        }
    }
}
