//
//  BirthView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class BirthView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "생년월일을 알려주세요"
        return label
    }()
    
    lazy var yeartextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "1990", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        return view
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "년"
        return label
    }()
    
    lazy var monthtextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "월"
        return label
    }()
    
    lazy var daytextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        return view
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "일"
        return label
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
        [infoLabel, yeartextField, yearLabel, monthtextField, monthLabel, daytextField, dayLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(125)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(228)
        }
        
        yeartextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(64)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yeartextField)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        monthtextField.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel)
            make.leading.equalTo(yearLabel.snp.trailing).offset(16)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yeartextField)
            make.leading.equalTo(monthtextField.snp.trailing)
        }
        
        daytextField.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.leading.equalTo(monthLabel.snp.trailing).offset(16)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(daytextField)
            make.leading.equalTo(daytextField.snp.trailing)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(yeartextField.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
