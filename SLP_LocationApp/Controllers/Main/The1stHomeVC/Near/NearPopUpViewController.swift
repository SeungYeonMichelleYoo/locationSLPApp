//
//  NearPopUpViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit

final class NearPopUpViewController: BaseViewController {
    
    var requestedUid = ""
    
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
                return
            case APIStudyRequestStatusCode.alreadyRecievedRequest.rawValue:
                return
            case APIStudyRequestStatusCode.opponentCancelledMatcting.rawValue:
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
}
