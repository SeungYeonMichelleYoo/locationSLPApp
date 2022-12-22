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
        view.backgroundColor = .red.withAlphaComponent(0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        
        mainView.closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        
        placeholderSetting()
        
    }
    @objc func closeBtnClicked() {
        self.dismiss(animated: true)
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
        return cell
    }
}

extension ChattingReviewViewController: UITextViewDelegate {
    func placeholderSetting() {
        mainView.textView.delegate = self
    }
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.BaseColor.gray7 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "자세한 피드백은 다른 새싹 친구들에게 큰 도움이 됩니다 (500자 이내 작성)"
            textView.textColor = Constants.BaseColor.gray7
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           guard let str = textView.text else { return true }
           let newLength = str.count + text.count - range.length
           return newLength <= 500
    }
}
