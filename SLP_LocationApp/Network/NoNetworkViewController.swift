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
        
        viewModel.idtokenGetTest { statusCode in
            switch statusCode {
            case 401:
                self.showToast(message: "휴대폰 인증을 다시 해주세요.")
            case 500, 501:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
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
