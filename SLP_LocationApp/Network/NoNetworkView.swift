//
//  NoNetworkView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit
import SnapKit

class NoNetworkView: BaseView {
    
    lazy var splashImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "splash_logo")
        return view
    }()
    
    lazy var splashLabel: UILabel = {
        let label = UILabel()
        label.text = "SeSAC Study"
        label.textColor = Constants.BaseColor.green
        label.font = UIFont(name: "Dongle-Regular", size: 72)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [splashImg, splashLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        splashImg.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(120)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(220)
            make.height.equalTo(264)
        }
        
        splashLabel.snp.makeConstraints { make in
            make.top.equalTo(splashImg.snp.bottom).offset(36)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
