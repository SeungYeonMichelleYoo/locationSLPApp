//
//  HeaderCollectionViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/24.
//
import UIKit
import SnapKit

class HeaderReusableView: UICollectionReusableView {
        
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title6_R12)
        label.numberOfLines = 1
        return label
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        self.addSubview(headerLabel)
                
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
