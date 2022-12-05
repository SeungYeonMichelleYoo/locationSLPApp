//
//  ChattingView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SnapKit

class ChattingView: BaseView {
    
    lazy var dateBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.BaseColor.gray7
        view.tintColor = .white
        view.layer.cornerRadius = 8
        view.titleLabel?.font =  UIFont.font(.Title5_M12)
        view.setTitle("오늘", for: .normal)
        view.sizeToFit()
        return view
    }()
    
    lazy var bellImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "bell")
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title3_M14)
        label.textColor = Constants.BaseColor.gray7
        label.text = "님과 매칭되었습니다."
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title4_R14)
        label.textColor = Constants.BaseColor.gray6
        label.text = "채팅을 통해 약속을 정해보세요."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [dateBtn, bellImg, infoLabel, detailLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        dateBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(82)
            make.height.equalTo(18)
        }
        
        bellImg.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
            make.size.equalTo(16)
            make.trailing.equalTo(dateBtn.snp.leading).offset(-4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(2)
            make.centerY.equalToSuperview()
        }
    }
}
