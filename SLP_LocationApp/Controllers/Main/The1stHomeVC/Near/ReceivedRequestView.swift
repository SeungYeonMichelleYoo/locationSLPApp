//
//  ReceivedRequestView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SnapKit

class ReceivedRequestView: BaseView {
    
    lazy var mainTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        return view
    }()
    
    lazy var btnsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [changeBtn, refreshBtn])
        view.distribution = .fillProportionally
        view.spacing = 8
        view.axis = .horizontal
        return view
    }()
    
    lazy var changeBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.backgroundColor = Constants.BaseColor.green
        view.setTitle("스터디 변경하기", for: .normal)
        view.titleLabel?.font = UIFont.font(.Body3_R14)
        return view
    }()
    
    lazy var refreshBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "btn_refresh"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainTableView, btnsStackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(500)
        }
        
        btnsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        refreshBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}
