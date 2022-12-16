//
//  ShopTabView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//

import UIKit
import SnapKit

class ShopTabView: BaseView {
    
    lazy var backimage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.BaseColor.gray2.cgColor
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_background_1")
        return view
    }()
    
    lazy var sesacImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_face_1")
        return view
    }()
    
    lazy var tabView: UIView = {
        let view = UIView()
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [backimage, sesacImg, tabView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backimage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(14)
            make.leading.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(14)
            make.height.equalTo(170)
        }
        
        sesacImg.snp.makeConstraints { make in
            make.centerX.equalTo(backimage)
            make.top.equalTo(backimage.snp.top).offset(32)
            make.bottom.equalTo(backimage.snp.bottom).offset(8)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(backimage.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
     
    }
}
