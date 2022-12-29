//
//  NearPopUpViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit

final class NearPopUpViewController: BaseViewController {
    
    var requestedUid = ""
    var receivedUid = ""
    var nick = ""
    
    var mainView = NearPopUpView()
    var viewModel = HomeViewModel()
    
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
        studyRequest()
    }
    
    func studyRequest() {
        viewModel.studyrequestVM(otheruid: requestedUid) { statusCode in
            switch statusCode {
            case APIStudyRequestStatusCode.success.rawValue:
                self.dismiss(animated: true)
                DispatchQueue.main.async {
                    self.showToast(message: "스터디 요청을 보냈습니다")
                }
                return
            case APIStudyRequestStatusCode.alreadyRecievedRequest.rawValue:
                self.studyAccept()
                DispatchQueue.main.async {
                    self.showToast(message: "상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다")
                    let vc = ChattingViewController()
                    self.transition(vc, transitionStyle: .push)
                }
                return
            case APIStudyRequestStatusCode.opponentCancelledMatcting.rawValue:
                self.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
                return
            case APIStudyRequestStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.studyRequest()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStudyRequestStatusCode.unAuthorized.rawValue:
                return
            case APIStudyRequestStatusCode.serverError.rawValue, APIStudyRequestStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func studyAccept() {
        viewModel.studyacceptVM(otheruid: receivedUid) { statusCode in
            switch statusCode {
            case APIStudyAcceptStatusCode.success.rawValue:
                self.checkCurrentStatus()
                return
            case APIStudyAcceptStatusCode.alreadyOpponentMatched.rawValue:
                self.showToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                return
            case APIStudyAcceptStatusCode.opponentCancelledMatcting.rawValue:
                self.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
                return
            case APIStudyAcceptStatusCode.alreadyIMatched.rawValue:
                self.showToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!")
                DispatchQueue.main.async {
                    self.checkCurrentStatus()
                }
                return
            case APIStudyRequestStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.studyAccept()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStudyRequestStatusCode.unAuthorized.rawValue:
                return
            case APIStudyRequestStatusCode.serverError.rawValue, APIStudyRequestStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func checkCurrentStatus() {
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                self.dismiss(animated: true)
                return
            case APIMyQueueStatusCode.noSearch.rawValue:
                return
            case APIMyQueueStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.checkCurrentStatus()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIMyQueueStatusCode.serverError.rawValue, APIMyQueueStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
}
