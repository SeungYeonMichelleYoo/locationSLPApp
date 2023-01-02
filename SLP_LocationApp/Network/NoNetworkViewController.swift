//
//  NoNetworkViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit
import SnapKit

final class NoNetworkViewController: BaseViewController {
    
    var mainView = NoNetworkView()
    
    var viewModel = UserViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white

        //파이어베이스 인증 o/x : 닉네임,홈화면 / 온보딩
        //서버 등록 o/x : 홈화면 / 닉네임
        print(UserDefaults.standard.string(forKey: "idToken") )
        if UserDefaults.standard.string(forKey: "idToken") == nil {
            self.viewModel.refreshIDToken { isSuccess in
                if isSuccess! {
                    self.userCheckRecursion()
                } else {
                    self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                }
            }
        } else {
            userCheckRecursion()
        }
    }
    
    func userCheckRecursion() {
        viewModel.userCheckVM { user, statusCode in
            print(statusCode)
            print(UserDefaults.standard.string(forKey: "idToken"))
            switch statusCode {
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
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
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            default:
                break
            }

            switch statusCode {
            case APIStatusCode.success.rawValue: //로그인 성공시
                let vc = TabBarViewController()
                vc.setNick(nick: user!.nick)
                vc.setSesac(sesac: user!.sesac)
                UserDefaults.standard.set(user!.uid, forKey: "myUID")
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            case APIStatusCode.forbiddenNickname.rawValue:
                let vc = NicknameViewController()
                self.transition(vc, transitionStyle: .push)
                return
            case APIStatusCode.unAuthorized.rawValue:
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            default:
                break
            }
        }
    }
}
