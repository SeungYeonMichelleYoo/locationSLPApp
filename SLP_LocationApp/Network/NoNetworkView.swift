//
//  NoNetworkView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit
import SnapKit

class NoNetworkView: BaseView {
    
    lazy var startBtn: OKButton = {
        let view = OKButton(frame: .zero)
        view.backgroundColor = Constants.BaseColor.green
        view.setTitle("시작하기", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [startBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
            
        startBtn.snp.makeConstraints { make in
//            make.top.equalTo(pageControl.snp.bottom).offset(42)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
