//
//  EmailView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class EmailView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Display1_R20)
        label.textAlignment = .center
        label.text = "이메일을 입력해 주세요"
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title2_R16)
        label.textColor = Constants.BaseColor.gray7
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "휴데폰 번호 변경 시 인증을 위해 사용해요"
        return label
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "SeSAC@email.com", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        view.keyboardType = .emailAddress
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
        [infoLabel, detailLabel, textField, sendBtn].forEach {
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
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(76)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
