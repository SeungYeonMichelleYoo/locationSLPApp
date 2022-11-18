//
//  ExpandableTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit
import SnapKit

class ExpandableTableViewCell: UITableViewCell {
    
    //MARK: - totalStackView
    lazy var totalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [grayView])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = Constants.BaseColor.gray2.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var nickStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nickLabel, downBtn])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.text = "김새싹"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title1_M16)
        return label
    }()

    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btn.tintColor = Constants.BaseColor.gray7
        return btn
    }()
    
    //MARK: - show/hidden expandableView
    lazy var expandableView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, titleStackView, reviewLabel, textView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
        
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 타이틀"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    //MARK: - 새싹 타이틀 스택뷰로 구성
    lazy var titleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [collectionView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionViewLayout())
        view.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.text = "첫 리뷰를 기다리는 중이에요!"
        textView.textColor = Constants.BaseColor.gray6
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.contentView.addSubview(totalStackView)
//        totalStackView.addSubview(grayView)
        
        [nickStackView, expandableView].forEach {
            grayView.addSubview($0)
        }
        
//        [nickLabel, downBtn].forEach {
//            nickStackView.addSubview($0)
//        }
        
//        [titleLabel, titleStackView, reviewLabel, textView].forEach {
//            expandableView.addSubview($0)
//        }
        titleStackView.addSubview(collectionView)
      
        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
        nickStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
    
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(nickStackView.snp.bottom)
            make.leading.trailing.equalTo(grayView)
            make.bottom.equalToSuperview()
        }
        
        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nickStackView)
            make.leading.equalTo(nickStackView.snp.leading)//.offset(8)
            make.width.equalTo(200)
        }
        
        downBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nickLabel)
            make.trailing.equalTo(nickStackView.snp.trailing)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(expandableView.snp.top)
            make.leading.equalTo(expandableView).inset(16)
        }
                
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(expandableView.snp.leading)
            make.trailing.equalTo(expandableView.snp.trailing)
            make.height.equalTo(104)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom)
            make.leading.equalTo(expandableView.snp.leading).inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom)
            make.leading.equalTo(expandableView.snp.leading).inset(16)
            make.height.equalTo(40)
        }
        
    }
    
    static func imageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let itemSpacing : CGFloat = 4
        let myWidth : CGFloat = UIScreen.main.bounds.width * 0.4
        let myHeight : CGFloat = 32
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        return layout
    }
}
