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
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
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
        
        image.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
            make.height.equalTo(image.snp.width)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(227)
            make.height.equalTo(76)
        }
    }
}
