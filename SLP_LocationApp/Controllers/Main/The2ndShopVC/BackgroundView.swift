//
//  BackgroundView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import SnapKit

class BackgroundView: BaseView {
    
    lazy var backimage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "sesac_background_1")
        return view
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [backimage].forEach {
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
    }
}
