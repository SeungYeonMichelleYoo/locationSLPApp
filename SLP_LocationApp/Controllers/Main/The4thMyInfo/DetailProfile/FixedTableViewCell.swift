//
//  FixedTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/16.
//

import UIKit
import SnapKit
import MultiSlider

protocol FixedTableDelegate: AnyObject {
    func maleButtonTapped()
    func femaleButtonTapped()
    func withdrawBtnTapped()
    func sliderTapped()
}

class FixedTableViewCell: UITableViewCell {
    
    var cellDelegate: FixedTableDelegate?
        
    lazy var fixedView: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - gender
    lazy var genderView: UIView = {
        let view = UIView()
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
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        view.inactive()
        return view
    }()
    
    lazy var femaleBtn: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        view.inactive()
        return view
    }()
    
    //MARK: - study
    lazy var studyView: UIView = {
        let view = UIView()
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
    lazy var searchableView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 번호 검색 허용"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var controlSwitch: UISwitch = {
        let controlSwitch: UISwitch = UISwitch()
        controlSwitch.onTintColor = Constants.BaseColor.green
        return controlSwitch
    }()
    
    //MARK: - age
    lazy var ageView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var ageInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.textAlignment = .left
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "18 - 35"
        label.textAlignment = .right
        label.font = UIFont.font(.Title3_M14)
        label.textColor = Constants.BaseColor.green
        return label
    }()
    
    lazy var slider: MultiSlider = {
        let slider = MultiSlider()
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.orientation = .horizontal
        slider.outerTrackColor = Constants.BaseColor.gray2
        slider.tintColor = Constants.BaseColor.green
        slider.trackWidth = 10
        slider.hasRoundTrackEnds = true
        slider.showsThumbImageShadow = true
        slider.thumbCount = 2
        slider.thumbImage = UIImage(named: "sliderimage")
        slider.value = [18, 35]
        return slider
    }()
    
    lazy var withdrawBtn: UIButton = {
        let view = UIButton()
        view.setTitle("회원탈퇴", for: .normal)
        view.titleLabel?.font = UIFont.font(.Title4_R14)
        view.setTitleColor(.black, for: .normal)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.maleBtn.addTarget(self, action: #selector(maleBtnClicked), for:.touchUpInside)
        self.femaleBtn.addTarget(self, action: #selector(femaleBtnClicked), for:.touchUpInside)
        self.withdrawBtn.addTarget(self, action: #selector(withdrawBtnClicked), for:.touchUpInside)
        self.slider.addTarget(self, action: #selector(sliderClicked), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderClicked), for: .touchUpInside)
        layout()
    }
    @objc func maleBtnClicked() {
        cellDelegate?.maleButtonTapped()
    }
    @objc func femaleBtnClicked() {
        cellDelegate?.femaleButtonTapped()
    }
    @objc func withdrawBtnClicked() {
        cellDelegate?.withdrawBtnTapped()
    }
    @objc func sliderClicked() {
        cellDelegate?.sliderTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.addSubview(fixedView)
        
        [genderView, studyView, searchableView, ageView, slider, withdrawBtn].forEach {
            fixedView.addSubview($0)
        }
        
        [genderLabel, maleBtn, femaleBtn].forEach {
            genderView.addSubview($0)
        }
        
        [studyLabel, textField].forEach {
            studyView.addSubview($0)
        }
        
        [toggleLabel, controlSwitch].forEach {
            searchableView.addSubview($0)
        }
        
        [ageInfoLabel, ageLabel].forEach {
            ageView.addSubview($0)
        }
        
        fixedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        genderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(genderView)
            make.leading.equalToSuperview()
        }
                
        femaleBtn.snp.makeConstraints { make in
            make.centerY.equalTo(genderView)
            make.trailing.equalTo(genderView.snp.trailing).inset(4)
            make.width.equalTo(52)
            make.height.equalTo(44)
        }
        
        maleBtn.snp.makeConstraints { make in
            make.centerY.equalTo(genderView)
            make.trailing.equalTo(femaleBtn.snp.leading).offset(-4)
            make.width.equalTo(52)
            make.height.equalTo(44)
        }
        
        //MARK: - studyview
        studyView.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(fixedView)
            make.height.equalTo(48)
        }

        studyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(studyView)
            make.leading.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalTo(studyLabel)
            make.trailing.equalTo(studyView.snp.trailing).inset(4)
        }

        //MARK: - searchableView
        searchableView.snp.makeConstraints { make in
            make.top.equalTo(studyView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(fixedView)
            make.height.equalTo(48)
        }

        toggleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(searchableView)
            make.leading.equalToSuperview()
        }

        controlSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(searchableView)
            make.trailing.equalTo(searchableView.snp.trailing).inset(4)
        }

        //MARK: - ageView
        ageView.snp.makeConstraints { make in
            make.top.equalTo(searchableView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(fixedView)
            make.height.equalTo(48)
        }

        ageInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageView)
            make.leading.equalToSuperview()
        }

        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageView)
            make.trailing.equalToSuperview().inset(4)
            make.width.equalTo(50)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(ageInfoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        withdrawBtn.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(30)
            make.leading.equalToSuperview()
        }
    }
}
