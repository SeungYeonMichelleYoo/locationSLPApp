//
//  NameTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit
import SnapKit

class NameTableViewCell: UITableViewCell {
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.image = UIImage(named:"profile_img")
        return img
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.font(.Title1_M16)
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = Constants.BaseColor.gray7
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.backgroundColor = .white
        
        [image, titleLabel, nextBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(14)
            make.centerY.equalTo(contentView)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(image.snp.trailing).offset(14)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.width.equalTo(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(22)
        }
        
    }
}
