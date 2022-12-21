//
//  ChattingReportView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit
import SnapKit

class ChattingReportView: BaseView {
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 1
        return containerView
    }()
    
    lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.layer.cornerRadius = 8
        infoView.clipsToBounds = true
        return infoView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 신고"
        label.font = UIFont.font(.Body1_M16)
        return label
    }()
    
    lazy var closeBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "close_chat"), for: .normal)
        return view
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "다시는 해당 새싹과 매칭되지 않습니다"
        label.font = UIFont.font(.Title4_R14)
        label.textColor = Constants.BaseColor.green
        return label
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionViewLayout())
        view.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Constants.BaseColor.gray1
        view.textColor = Constants.BaseColor.black
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var reportBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("신고하기", for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(containerView)
        containerView.addSubview(infoView)
        [titleLabel, closeBtn, detailLabel, collectionView, textView, reportBtn].forEach {
            infoView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(410)
            make.width.equalTo(343)
        }
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.top).offset(17)
            make.centerX.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.top).offset(16)
            make.trailing.equalTo(infoView.snp.trailing).inset(16)
            make.size.equalTo(24)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.leading.equalTo(infoView.snp.leading).offset(16)
            make.trailing.equalTo(infoView.snp.trailing).inset(16)
            make.height.equalTo(124)
        }
        
        reportBtn.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(16)
            make.trailing.equalTo(infoView.snp.trailing).inset(16)
            make.trailing.equalTo(infoView.snp.bottom).inset(16)
            make.height.equalTo(48)
        }
    }
    
    static func imageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let itemSpacing : CGFloat = 4
        let myWidth : CGFloat = UIScreen.main.bounds.width * 0.33
        let myHeight : CGFloat = 32
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        return layout
    }
}
