//
//  ImageTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/19.
//

import UIKit
import SnapKit

class ImageTableViewCell: UITableViewCell {
    
    lazy var backimage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_background_1")
        return view
    }()
    
    lazy var sesacImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_face_1")
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.contentView.backgroundColor = .white
        
        [backimage, sesacImg].forEach {
            contentView.addSubview($0)
        }
        
        backimage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        sesacImg.snp.makeConstraints { make in
            make.centerX.equalTo(backimage)
            make.top.equalTo(backimage.snp.top).offset(32)
            make.bottom.equalTo(backimage.snp.bottom).offset(8)
        }
    }
}
