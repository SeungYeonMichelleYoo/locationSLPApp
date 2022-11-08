//
//  OnboardingCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
        
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    func setup(_ slide: OnboardingSlide) {
        image.image = slide.image
        contentLabel.text = slide.labelContent
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        [contentLabel, image].forEach {
            contentView.addSubview($0)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(72)
            make.centerX.equalTo(contentView)
            make.width.equalTo(227)
            make.height.equalTo(76)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(56)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
