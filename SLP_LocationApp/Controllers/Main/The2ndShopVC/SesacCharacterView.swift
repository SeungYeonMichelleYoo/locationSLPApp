//
//  SesacCharacterView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import SnapKit

class SesacCharacterView: BaseView {
    
    //MARK: - collectionview (사진 목록 2열로)
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let itemSpacing : CGFloat = 8
        
        let myWidth = (UIScreen.main.bounds.width - itemSpacing * 6) / 2
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        layout.itemSize = CGSize(width: myWidth , height: 280)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SesacFaceCollectionViewCell.self, forCellWithReuseIdentifier: "SesacFaceCollectionViewCell")
        return cv
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(230)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
