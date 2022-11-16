//
//  FixedTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/16.
//

import UIKit
import SnapKit

class FixedTableViewCell: UITableViewCell {
        
    lazy var bigView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var fixedStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [genderView, studyView, searchableView, ageView, slider, withdrawLabel])
        view.axis = .horizontal
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
    
    lazy var maleBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setImage(UIImage(named: "남자"), for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var femaleBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.setImage(UIImage(named: "여자"), for: .normal)
        view.backgroundColor = .white
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
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var ageInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "18 - 35"
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
    
    //코드로 tableview짤 때(스토리보드 없이), 초기화 해야하는 이유: 인터페이스 빌더에서는 자동으로 초기화를 해주지만, 코드에서는 인터페이스 빌더를 사용하는게 아니기 때문
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.addSubview(bigView)
        bigView.addSubview(fixedStackView)
        
        [genderView, studyView, searchableView, ageView, slider, withdrawLabel].forEach {
            fixedStackView.addSubview($0)
        }
        
//        nickLabel.snp.makeConstraints { make in
//           
//        }
//        
//        downBtn.snp.makeConstraints { make in
//        
//        }
    }
}
