//
//  WithdrawView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/21.
//

import UIKit
import SnapKit

class WithdrawView: BaseView {

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 1
        return containerView
      }()
    
    lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.layer.cornerRadius = 8
        infoView.clipsToBounds = true
        return infoView
      }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 탈퇴하시겠습니까?"
        label.font = UIFont.font(.Body1_M16)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var cancelBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("취소", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        view.cancel()
        return view
    }()
    
    lazy var okBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("확인", for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        view.fill()
        return view
    }()

          
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(containerView)
        containerView.addSubview(infoView)
        [titleLabel, detailLabel, cancelBtn, okBtn].forEach {
            infoView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(320)
        }
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        okBtn.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(16)
            make.leading.equalTo(cancelBtn.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(cancelBtn)
        }
    }
}
