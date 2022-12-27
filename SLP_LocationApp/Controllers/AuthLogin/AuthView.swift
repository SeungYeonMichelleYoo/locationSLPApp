//
//  AuthView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class AuthView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Display1_R20)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "새싹 서비스 이용을 위해\n 휴대폰 번호를 입력해 주세요"
        return label
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "휴대폰 번호(-없이 숫자만 입력)", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        view.keyboardType = .phonePad
        return view
    }()
    
    lazy var sendBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setTitle("인증 문자 받기", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [infoLabel, textField, sendBtn].forEach {
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
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
