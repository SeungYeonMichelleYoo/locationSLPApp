//
//  SMSCodeView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit
import SnapKit

class SMSCodeView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "인증번호가 문자로 전송되었어요"
        return label
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "인증번호 입력", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        return view
    }()
    
    lazy var resendBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("재전송", for: .normal)
        return view
    }()
    
    lazy var startBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("인증하고 시작하기", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [infoLabel, textField, resendBtn, startBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(125)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(64)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        resendBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.leading.equalTo(textField.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        startBtn.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
