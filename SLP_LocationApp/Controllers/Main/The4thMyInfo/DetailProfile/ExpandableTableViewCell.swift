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
        label.font = UIFont.font(.Title1_M16)
        return label
    }()
    
    //MARK: - 새싹 타이틀 늘어날 수 있으므로 스택뷰로 구성
    lazy var titleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [collectionView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = spacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title1_M16)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.text = "첫 리뷰를 기다리는 중이에요!"
        textView.textColor = Constants.BaseColor.black
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
        [grayView].forEach {
            totalStackView.addSubview($0)
        }
        [nickStackView, expandableView].forEach {
            grayView.addSubview($0)
        }
        [titleLabel, titleStackView, reviewLabel, textView].forEach {
            expandableView.addSubview($0)
        }
        [collectionView].forEach {
            titleStackView.addSubview($0)
        }
    
        totalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(contentView)
        }
        
        grayView.snp.makeConstraints { make in
            make.edges.equalTo(totalStackView)
        }
       
        nickStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(grayView)
            //높이? (58 아니면 show할 경우 더 늘어남
            make.height.equalTo(60)
        }
    
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(nickStackView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            //높이?
            make.height.equalTo(240)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(grayView).inset(16)
            make.width.equalTo(280)
        }
        
        downBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nickLabel)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(expandableView.snp.top)
            make.leading.equalTo(grayView).inset(16)
        }
                
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(grayView.snp.leading).offset(16)
            make.trailing.equalTo(grayView.snp.leading).inset(16)
            make.height.equalTo(100) //??????
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(titleStackView)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(24)
            make.leading.equalTo(grayView.snp.leading).inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.leading.equalTo(grayView.snp.leading).inset(16)
        }
        
    }
}
