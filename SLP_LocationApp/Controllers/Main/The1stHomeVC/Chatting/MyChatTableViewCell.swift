//
//  MyChatTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit
import SnapKit

class MyChatTableViewCell: UITableViewCell {
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = Constants.BaseColor.gray6
        label.font = UIFont.font(.Title6_R12)
        return label
    }()
    
    lazy var chatLabel: UILabel = {
        let view = UILabel()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = Constants.BaseColor.whitegreen
        view.font = UIFont.font(.Body3_R14)
        view.numberOfLines = 2
        view.text = "답장 테스트 안녕하세요 답장 테스트 안녕하세요\n 알고리즘 스터디"
        return view
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
        
        [timeLabel, chatLabel].forEach {
            contentView.addSubview($0)
        }
    
        chatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel.snp.bottom)
            make.trailing.equalTo(chatLabel.snp.leading).offset(-8)
            make.leading.lessThanOrEqualTo(100)
        }
    }
}
