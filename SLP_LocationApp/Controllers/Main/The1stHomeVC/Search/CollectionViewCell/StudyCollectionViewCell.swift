//
//  StudyCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/24.
//

import UIKit
import SnapKit

class StudyCollectionViewCell: UICollectionViewCell {
    
    lazy var nearBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constants.BaseColor.black
        config.background.cornerRadius = 8
        config.background.strokeColor = Constants.BaseColor.gray4
        config.background.strokeWidth = 1
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 32, bottom: 8, trailing: 32)
        view.configuration = config
        view.titleLabel?.font =  UIFont.font(.Title4_R14)
        view.sizeToFit()
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        contentView.addSubview(nearBtn)
                   
        nearBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
}
