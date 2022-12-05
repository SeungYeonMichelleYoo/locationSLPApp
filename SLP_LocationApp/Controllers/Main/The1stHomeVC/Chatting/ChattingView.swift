//
//  ChattingView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SnapKit

class ChattingView: BaseView {
    
    lazy var dateBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.BaseColor.gray7
        view.tintColor = .white
        view.layer.cornerRadius = 8
        view.titleLabel?.font =  UIFont.font(.Title5_M12)
        let now = Date()
        view.setTitle("\(now.getMonthDate())", for: .normal)
        return view
    }()
    
    lazy var bellImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "bell")
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title3_M14)
        label.textColor = Constants.BaseColor.gray7
        label.text = "님과 매칭되었습니다"
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.Title4_R14)
        label.textColor = Constants.BaseColor.gray6
        label.text = "채팅을 통해 약속을 정해보세요 :)"
        return label
    }()
    
    lazy var mainTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: "YourChatTableViewCell")
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatTableViewCell")
        return view
      }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.addLeftPadding()
        view.attributedPlaceholder = NSAttributedString(string: "띄어쓰기로 복수 입력이 가능해요", attributes: [.foregroundColor: Constants.BaseColor.gray6])
        view.backgroundColor = Constants.BaseColor.gray1
        view.font = UIFont.font(.Title4_R14)
        return view
    }()
    
    lazy var sendBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "chat_send"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [dateBtn, bellImg, infoLabel, detailLabel, mainTableView, textField, sendBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        dateBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(18)
        }
        
        bellImg.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
            make.size.equalTo(16)
            make.trailing.equalTo(dateBtn.snp.leading).offset(-4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
            make.leading.equalTo(bellImg.snp.trailing).offset(4)
            make.centerY.equalTo(bellImg)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.trailing.equalTo(textField.snp.trailing).inset(14)
            make.size.equalTo(20)
            make.centerY.equalTo(textField)
        }
    }
}
