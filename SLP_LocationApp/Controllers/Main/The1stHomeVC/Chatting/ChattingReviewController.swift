//
//  ChattingReviewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit

final class ChattingReviewViewController: BaseViewController {
    
    var mainView = ChattingReviewView()
    var buttonTitle = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    var reputation = [0,0,0,0,0,0]
    var viewModel = HomeViewModel()
    var matchedNick = ""
    var otheruid = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        
        mainView.closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        mainView.okBtn.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
        mainView.detailLabel.text = "\(matchedNick)님과의 스터디는 어떠셨나요?"
        
        placeholderSetting()
    }
    
    @objc func closeBtnClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func okBtnClicked() {
        sendReview()
    }
    
    private func sendReview() {
        viewModel.sendReviewVM(otheruid: otheruid, comment: mainView.textView.text!, reputation: reputation + [0, 0, 0]) { statusCode in
            switch statusCode {
            case APIStopStudyStatusCode.success.rawValue:
                self.dismiss(animated: false)
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
            case APIStopStudyStatusCode.matched.rawValue:
                return
            case APIStopStudyStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.sendReview()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStopStudyStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
                               
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과) + textview 외의 화면 클릭시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
        view.endEditing(true)
    }
}
extension ChattingReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleBtn.setTitle("\(buttonTitle[indexPath.item])", for: .normal)
        cell.titleBtn.tag = indexPath.item
        cell.titleBtn.addGestureRecognizer(getPressGesture())
        return cell
    }
}

extension ChattingReviewViewController: UITextViewDelegate {
    func placeholderSetting() {
        mainView.textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "자세한 피드백은 다른 새싹 친구들에게 큰 도움이 됩니다 (500자 이내 작성)"
            textView.textColor = Constants.BaseColor.gray7
            mainView.textView.resignFirstResponder()
            mainView.okBtn.disable()
        } else {
            mainView.okBtn.fill()
        }
    }
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.BaseColor.gray7 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 500
    }
}

extension ChattingReviewViewController: UIGestureRecognizerDelegate {
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func btnPress(gestureRecognizer: UITapGestureRecognizer) {
        if (mainView.collectionView.cellForItem(at: IndexPath(item: (gestureRecognizer.view as! UIButton).tag, section: 0)) as! TitleCollectionViewCell).titleBtn.backgroundColor != Constants.BaseColor.green {
            (mainView.collectionView.cellForItem(at: IndexPath(item: (gestureRecognizer.view as! UIButton).tag, section: 0)) as! TitleCollectionViewCell).titleBtn.fill()
            self.reputation[(gestureRecognizer.view as! UIButton).tag] = 1
        } else {
            (mainView.collectionView.cellForItem(at: IndexPath(item: (gestureRecognizer.view as! UIButton).tag, section: 0)) as! TitleCollectionViewCell).titleBtn.inactive()
            self.reputation[(gestureRecognizer.view as! UIButton).tag] = 0
        }
    }
}
