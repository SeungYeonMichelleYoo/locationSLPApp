//
//  YourChatTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit
import SnapKit

class YourChatTableViewCell: UITableViewCell {
    
    lazy var chatLabel: UILabel = {
        let view = UILabel()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.BaseColor.gray4.cgColor
        view.font = UIFont.font(.Body3_R14)
        view.numberOfLines = 2
        view.text = "테스트 테스트 안녕하세요\n 알고리즘 스터디"
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        let now = Date()
        label.text = "\(now.getTime())"
        label.textColor = Constants.BaseColor.gray6
        label.font = UIFont.font(.Title6_R12)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        [chatLabel, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(100)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.trailing).offset(8)
            make.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
}
