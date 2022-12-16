//
//  ShopBackgroundView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import SnapKit

class ShopBackgroundView: BaseView {
       
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let itemSpacing : CGFloat = 8
        let myWidth = UIScreen.main.bounds.width
        
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: myWidth , height: 165)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ShopBackgroundCollectionViewCell.self, forCellWithReuseIdentifier: "ShopBackgroundCollectionViewCell")
        cv.showsVerticalScrollIndicator = false
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
            make.top.equalTo(self.safeAreaLayoutGuide).inset(250)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
