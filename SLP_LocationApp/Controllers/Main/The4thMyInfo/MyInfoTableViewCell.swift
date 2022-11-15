//
//  MyInfoTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class MyInfoTableViewCell: UITableViewCell {
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.font(.Title2_R16)
        return label
    }()
    
  
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
    }
    
    //MARK: - subview 추가 및 제약조건
    private func layout() {
        
        [image, titleLabel].forEach {
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
    }
}
