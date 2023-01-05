//
//  NearPeopleTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/03.
//
import UIKit
import SnapKit

protocol NearPeopleTableDelegate: AnyObject {
    func requestBtnTapped(sender: UIButton!)
}

class NearPeopleTableViewCell: UITableViewCell {
    
    var cellDelegate: NearPeopleTableDelegate?
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_background_1")
        return view
    }()
    
    lazy var requestBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.BaseColor.error
        view.isUserInteractionEnabled = true
        view.tintColor = .white
        view.layer.cornerRadius = 8
        view.titleLabel?.font =  UIFont.font(.Title3_M14)
        view.setTitle("요청하기", for: .normal)
        view.sizeToFit()
        return view
    }()
    
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
    
    lazy var nickView: UIView = {
        let view = UIView()
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
    lazy var expandableView: UIView = {
        let view = UIView()
        return view
    }()
        
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 타이틀"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title6_R12)
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
        view.backgroundColor = .white
        return view
    }()
    
    lazy var studyLabel: UILabel = {
        let label = UILabel()
        label.text = "하고 싶은 스터디"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title6_R12)
        return label
    }()
    
    let studyCollectionView: DynamicHeightCollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
    
        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DemandStudyCollectionViewCell.self, forCellWithReuseIdentifier: "DemandStudyCollectionViewCell")
        cv.isScrollEnabled = false
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title6_R12)
        return label
    }()
    
    lazy var textView: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.font(.Body3_R14)
        textView.text = "첫 리뷰를 기다리는 중이에요!"
        textView.textColor = Constants.BaseColor.gray6
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
        self.requestBtn.addTarget(self, action: #selector(requestBtnClicked), for: .touchUpInside)
    }
    @objc func requestBtnClicked() {
        cellDelegate?.requestBtnTapped(sender: requestBtn.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.backgroundColor = .white
        
        [image, requestBtn, totalStackView].forEach {
            contentView.addSubview($0)
        }

                
        [nickView, expandableView].forEach {
            grayView.addSubview($0)
        }
        
        [nickLabel, downBtn].forEach {
            nickView.addSubview($0)
        }
        
        [titleLabel, titleStackView, studyLabel, studyCollectionView, reviewLabel, textView].forEach {
            expandableView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        requestBtn.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).inset(12)
            make.trailing.equalTo(image.snp.trailing).inset(12)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        totalStackView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
       
        nickView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(nickView.snp.bottom)
            make.leading.trailing.equalTo(grayView)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        downBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(nickView.snp.trailing).inset(16)
            make.size.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(expandableView.snp.top)
            make.leading.equalTo(expandableView).inset(16)
        }
                
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        studyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(24)
            make.leading.equalTo(expandableView.snp.leading).inset(16)
        }
        
        studyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.leading.equalTo(expandableView.snp.leading).inset(16)
            make.trailing.equalTo(expandableView.snp.trailing).inset(16)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(studyCollectionView.snp.bottom).offset(24)
            make.leading.equalTo(expandableView.snp.leading).inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
    }
    
    static func imageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let itemSpacing : CGFloat = 8
        let myWidth : CGFloat = UIScreen.main.bounds.width * 0.43
        let myHeight : CGFloat = 32
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        return layout
    }
    
//    static func horizontalCollectionViewLayout() -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        let itemSpacing : CGFloat = 4
//        let myWidth : CGFloat = UIScreen.main.bounds.width * 0.3
//        let myHeight : CGFloat = 32
//
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets.zero
//
//        layout.itemSize = CGSize(width: myWidth, height: myHeight)
//        return layout
//    }
}
