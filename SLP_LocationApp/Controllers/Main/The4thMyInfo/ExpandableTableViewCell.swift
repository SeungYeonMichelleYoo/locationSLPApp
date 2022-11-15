//
//  ExpandableTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit
import SnapKit

class ExpandableTableViewCell: UITableViewCell {
    
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.text = "김새싹"
        label.textColor = Constants.BaseColor.black
        label.font = UIFont.font(.Title1_M16)
        return label
    }()
    
    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btn.tintColor = Constants.BaseColor.gray7
        return btn
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
        
        [nickLabel, downBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        nickLabel.snp.makeConstraints { make in
           
        }
        
        downBtn.snp.makeConstraints { make in
        
        }
    }
}
