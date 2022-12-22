//
//  ChattingReportViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit

final class ChattingReportViewController: BaseViewController {
    
    var mainView = ChattingReportView()
    var buttonTitle = ["불법/사기", "불편한언행", "노쇼", "선정성", "인신공격", "기타"]
    
    override func loadView() {
        self.view = mainView
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
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
    
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
    }
}

extension ChattingReportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ChattingReportViewController: UITextViewDelegate {
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
            textView.text = "신고 사유를 적어주세요\n허위 신고 시 제재를 받을 수 있습니다"
            textView.textColor = Constants.BaseColor.gray7
        }
    }
}
