//
//  FixedTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/16.
//

import UIKit
import SnapKit

class FixedTableViewCell: UITableViewCell {
    
    lazy var fixedStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [genderView, studyView, searchableView, ageView, slider, withdrawLabel])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    //MARK: - gender
    lazy var genderView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [genderLabel, maleBtn, femaleBtn])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "내 성별"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var maleBtn: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.tintColor = Constants.BaseColor.black
        view.backgroundColor = Constants.BaseColor.green
        return view
    }()
    
    lazy var femaleBtn: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.tintColor = Constants.BaseColor.black
        view.backgroundColor = Constants.BaseColor.green
        return view
    }()
    
    //MARK: - study
    lazy var studyView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [studyLabel, textField])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var studyLabel: UILabel = {
        let label = UILabel()
        label.text = "자주하는 스터디"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "스터디를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : Constants.BaseColor.gray7])
        view.textColor = Constants.BaseColor.black
        view.keyboardType = .numberPad
        return view
    }()
    
    //MARK: - searchable
    lazy var searchableView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [toggleLabel, controlSwitch])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 번호 검색 허용"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var controlSwitch: UISwitch = {
        let swicth: UISwitch = UISwitch()
//        swicth.isOn = true
        return swicth
    }()
    
    //MARK: - age
    lazy var ageView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [ageInfoLabel, ageLabel])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    lazy var ageInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.textAlignment = .left
        label.font = UIFont.font(.Title4_R14)
        label.backgroundColor = .red
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "18 - 35"
        label.backgroundColor = .blue
        label.textAlignment = .right
        label.font = UIFont.font(.Title3_M14)
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    lazy var withdrawLabel: UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.addSubview(fixedStackView)
        
        fixedStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        genderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        genderLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(genderView)
            make.top.equalTo(genderView).inset(4)
            make.leading.equalTo(genderView.snp.leading)
        }
                
        femaleBtn.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.top)
            make.trailing.equalTo(genderView.snp.trailing).inset(4)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        
        maleBtn.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.top)
            make.trailing.equalTo(femaleBtn.snp.leading).offset(-4)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        
        //MARK: - studyview
        studyView.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom)
            make.leading.trailing.equalTo(fixedStackView)
            make.height.equalTo(48)
        }

        studyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(studyView)
            make.leading.equalTo(studyView.snp.leading)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalTo(studyLabel)
            make.trailing.equalTo(studyView.snp.trailing).inset(4)
        }

        //MARK: - searchableView
        searchableView.snp.makeConstraints { make in
            make.top.equalTo(studyView.snp.bottom)
            make.leading.trailing.equalTo(fixedStackView)
            make.height.equalTo(48)
        }

        toggleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(searchableView)
            make.leading.equalTo(searchableView.snp.leading)
        }

        controlSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(searchableView)
            make.trailing.equalTo(searchableView.snp.trailing).inset(4)
        }

        //MARK: - ageView
        ageView.snp.makeConstraints { make in
            make.top.equalTo(searchableView.snp.bottom)
            make.leading.trailing.equalTo(fixedStackView)
            make.height.equalTo(48)
        }

        ageInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(ageView.snp.top)
//            make.centerY.equalTo(ageView)
            make.leading.equalToSuperview()
            make.width.equalTo(100)
        }

        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(ageView.snp.top)
            make.trailing.equalToSuperview().inset(4)
            make.width.equalTo(70)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(ageInfoLabel.snp.bottom).offset(4)
            make.leading.equalTo(ageLabel.snp.leading)
            make.width.equalTo(100)
        }

        withdrawLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(40)
            make.leading.equalTo(ageLabel.snp.leading)
        }
    }
}
