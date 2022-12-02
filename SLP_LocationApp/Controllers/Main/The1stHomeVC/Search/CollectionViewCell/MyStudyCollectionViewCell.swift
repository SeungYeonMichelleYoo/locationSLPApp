//
//  MyStudyCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/24.
//
import UIKit
import SnapKit

class MyStudyCollectionViewCell: UICollectionViewCell {
    
    lazy var myBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constants.BaseColor.green
        config.background.cornerRadius = 8
        config.background.strokeColor = Constants.BaseColor.green
        config.background.strokeWidth = 1
        config.imagePlacement = NSDirectionalRectEdge.trailing
        config.image = UIImage(named: "close")
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 16, bottom: 8, trailing: 16)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont.font(.Title4_R14)
        view.sizeToFit()
        view.isUserInteractionEnabled = false
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myBtn.titleLabel?.font = nil
    }
    
    func cellSetting() {
        contentView.addSubview(myBtn)
       
        myBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
    }
}
