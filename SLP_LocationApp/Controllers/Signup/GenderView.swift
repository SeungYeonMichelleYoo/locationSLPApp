//
//  GenderView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit
import SnapKit

class GenderView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Font.font(.Display1_R20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "성별을 선택헤 주세요"
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Font.font(.Title2_R16)
        label.textColor = Constants.BaseColor.gray7
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        return label
    }()
    
    lazy var maleBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "maleButton"), for: .normal)
        return view
    }()
    
    lazy var femaleBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "femaleButton"), for: .normal)
        return view
    }()
    
    lazy var sendBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("다음", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [infoLabel, detailLabel, maleBtn, femaleBtn, sendBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(125)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        maleBtn.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(32)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(UIScreen.main.bounds.width - 48 / 2)
        }
        
        femaleBtn.snp.makeConstraints { make in
            make.top.equalTo(maleBtn.snp.top)
            make.leading.equalTo(maleBtn.snp.trailing).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(maleBtn.snp.width)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(maleBtn.snp.bottom).offset(32)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
