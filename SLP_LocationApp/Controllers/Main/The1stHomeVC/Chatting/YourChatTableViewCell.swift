//
//  YourChatTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit
import SnapKit

class YourChatTableViewCell: UITableViewCell {
    
    lazy var chatLabel: ChatPaddingLabel = {
        let view = ChatPaddingLabel()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.BaseColor.gray4.cgColor
        view.backgroundColor = .white
        view.font = UIFont.font(.Body3_R14)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
    }
    
    private func layout() {
        [chatLabel, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.leading.equalToSuperview().inset(12)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview().inset(12).priority(.low)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.trailing).offset(8)
            make.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
}
