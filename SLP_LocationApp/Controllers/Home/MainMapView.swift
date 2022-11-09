//
//  MainMapView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit
import SnapKit

class MainMapView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "메인뷰"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [infoLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(125)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(228)
        }
    }
}
