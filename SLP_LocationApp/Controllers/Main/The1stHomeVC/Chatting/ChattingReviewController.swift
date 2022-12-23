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
        
        placeholderSetting()
    }
    
    @objc func closeBtnClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func okBtnClicked() {
       print("okokok")
    }
    
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
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
        } else {
            (mainView.collectionView.cellForItem(at: IndexPath(item: (gestureRecognizer.view as! UIButton).tag, section: 0)) as! TitleCollectionViewCell).titleBtn.inactive()
        }
    }
}
