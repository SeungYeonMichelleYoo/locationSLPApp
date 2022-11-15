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
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        return btn
    }()
    
    //코드로 tableview짤 때(스토리보드 없이), 초기화 해야하는 이유: 인터페이스 빌더에서는 자동으로 초기화를 해주지만, 코드에서는 인터페이스 빌더를 사용하는게 아니기 때문
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        titleLabel.text = nil
//        nextBtn.title = nil ????
    }
    
    private func layout() {
        
        [image, titleLabel, nextBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(14)
            make.top.equalTo(contentView.snp.top).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(14)
            make.leading.equalTo(image.snp.trailing).offset(14)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(14)
            make.width.equalTo(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(22)
        }
        
    }
}
