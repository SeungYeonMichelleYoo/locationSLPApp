//
//  SearchView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//
import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var nearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title6_R12)
        label.text = "지금 주변에는"
        return label
    }()

    lazy var nearCollectionView: DynamicHeightCollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .zero
//        layout.itemSize = CGSize(width: 80, height: 40) //height 값???
        layout.scrollDirection = .vertical
    
        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: "StudyCollectionViewCell")
        cv.isScrollEnabled = false
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title6_R12)
        label.text = "내가 하고 싶은"
        return label
    }()
    
    lazy var myCollectionView: DynamicHeightCollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
    
        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MyStudyCollectionViewCell.self, forCellWithReuseIdentifier: "MyStudyCollectionViewCell")
        cv.isScrollEnabled = false
        return cv
    }()
    
    lazy var searchBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("새싹 찾기", for: .normal)
        view.fill()
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
        [nearLabel, nearCollectionView, myLabel, myCollectionView, searchBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        nearLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        nearCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        myLabel.snp.makeConstraints { make in
            make.top.equalTo(nearCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        myCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
