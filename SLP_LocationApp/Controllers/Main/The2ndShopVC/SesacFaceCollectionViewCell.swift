//
//  SesacFaceCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/16.
//
import UIKit
import SnapKit

class SesacFaceCollectionViewCell: UICollectionViewCell {
    
    lazy var sesacImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "sesac_face_1")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 새싹"
        label.textColor = .black
        label.font = UIFont.font(.Title2_R16)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        label.textColor = .black
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
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        [sesacImg, titleLabel, contentLabel, priceBtn].forEach {
            contentView.addSubview($0)
        }
        
        sesacImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(sesacImg.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImg.snp.bottom).offset(8)
            make.leading.equalTo(sesacImg.snp.leading)
            make.trailing.equalTo(sesacImg.snp.trailing)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(sesacImg.snp.trailing)
        }
        
        priceBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(sesacImg.snp.trailing).offset(-8)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
    }
}
