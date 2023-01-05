//
//  EmptyBigView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/03.
//
import UIKit
import SnapKit

class EmptyBigView: BaseView {
    
    lazy var graySesac: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "graysesac")
        return view
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Display1_R20)
        label.textColor = .black
        label.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title4_R14)
        label.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        label.textColor = Constants.BaseColor.gray7
        return label
    }()
          
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [graySesac, mainLabel, detailLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        graySesac.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(graySesac.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
