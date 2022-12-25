//
//  ChattingCancelViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit

final class ChattingCancelViewController: BaseViewController {
    
    var mainView = ChattingCancelView()
    var viewModel = HomeViewModel()
    var otheruid = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
        mainView.cancelBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        mainView.okBtn.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
    }
    
    @objc func closeBtnClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func okBtnClicked() {
        studyDodge()
    }
    
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
    }
    
    func studyDodge() {
        viewModel.studydodgeVM(otheruid: otheruid) { statusCode in
            switch statusCode {
            case APIStudyDodgeStatusCode.success.rawValue:
                self.checkMatchState()
                return
            case APIStudyDodgeStatusCode.wrongOtherUid.rawValue:
                print("wrongOtherUid")
                return
            case APIStudyDodgeStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.studyDodge()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStudyDodgeStatusCode.serverError.rawValue, APIStudyDodgeStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func checkMatchState() {
        self.viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                return
            case APIMyQueueStatusCode.noSearch.rawValue: //일반상태
                //홈화면으로 이동
                var vcList = self.navigationController!.viewControllers
                var count = 0
                for vc in vcList {
                    if vc.isKind(of: FindTotalViewController.self) ||
                        vc.isKind(of: NearViewController.self) ||
                        vc.isKind(of: NearPopUpViewController.self) ||
                        vc.isKind(of: ReceivedRequestViewController.self) ||
                        vc.isKind(of: ReceivedPopUpViewController.self) ||
                        vc.isKind(of: ChattingViewController.self) {
                        vcList.remove(at: count)
                        continue
                    }
                    count = count + 1
                }
                self.navigationController!.viewControllers = vcList
                return
            case APIMyQueueStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.studyDodge()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIMyQueueStatusCode.serverError.rawValue, APIMyQueueStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func setUid(otheruid: String) {
        self.otheruid = otheruid
    }
}
