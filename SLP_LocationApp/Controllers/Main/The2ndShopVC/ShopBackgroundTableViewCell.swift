//
//  ShopBackgroundTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/16.
//
import UIKit
import SnapKit

class ShopBackgroundTableViewCell: UITableViewCell {
    
    lazy var backgroundImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "sesac_background_1")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "하늘 공원"
        label.font = UIFont.font(.Title3_M14)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        label.font = UIFont.font(.Body3_R14)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var priceBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.BaseColor.gray7
        view.tintColor = .white
        view.layer.cornerRadius = 8
        view.titleLabel?.font =  UIFont.font(.Title5_M12)
        view.setTitle("보유", for: .normal)
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
        
        [backgroundImg, titleLabel, contentLabel, priceBtn].forEach {
            contentView.addSubview($0)
        }
        
        backgroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImg.snp.top).offset(30)
            make.leading.equalTo(backgroundImg.snp.trailing).offset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(backgroundImg.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        priceBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
    }
}
