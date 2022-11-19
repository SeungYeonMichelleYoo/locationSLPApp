//
//  TitleCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/16.
//
import UIKit
import SnapKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    lazy var titleBtn: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Title4_R14)
        view.inactive()
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
        self.backgroundColor = Constants.BaseColor.background
        contentView.addSubview(titleBtn)
        
        titleBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.height.equalTo(32)
            make.width.equalTo(100)
        }
    }
}
