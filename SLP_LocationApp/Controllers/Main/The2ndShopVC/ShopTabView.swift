//
//  ShopTabView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//

import UIKit
import SnapKit

class ShopTabView: BaseView {
    
    lazy var tabUIView: UIView = {
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
        self.addSubview(tabUIView)
    }
    
    override func setConstraints() {
        tabUIView.snp.makeConstraints { make in
            make.top.equalTo(ShopView().backimage.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
     
    }
}
