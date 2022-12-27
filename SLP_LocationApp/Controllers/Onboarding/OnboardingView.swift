//
//  OnboardingView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit
import SnapKit

class OnboardingView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 564)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = Constants.BaseColor.gray5
        view.currentPageIndicatorTintColor = Constants.BaseColor.black
        view.numberOfPages = 3
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var startBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.backgroundColor = Constants.BaseColor.green
        view.setTitle("시작하기", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [collectionView, pageControl, startBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(36)
            make.width.greaterThanOrEqualTo(48)
            make.height.equalTo(8)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        startBtn.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(42)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
