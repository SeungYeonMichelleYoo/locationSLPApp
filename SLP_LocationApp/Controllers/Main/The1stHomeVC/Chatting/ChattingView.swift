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
        view.backgroundColor = .white
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: "YourChatTableViewCell")
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatTableViewCell")
        return view
      }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 8
        view.backgroundColor = Constants.BaseColor.gray1
        view.font = UIFont.font(.Body3_R14)
        view.textColor = Constants.BaseColor.gray7
        view.text = "메시지를 입력하세요"
        return view
    }()
    
    lazy var sendBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "chat_send_gray"), for: .normal)
        return view
    }()
    
    lazy var plusbigView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var menuView: MenuView = {
        let view = MenuView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [dateBtn, bellImg, infoLabel, detailLabel, mainTableView, textView, sendBtn, plusbigView].forEach {
            self.addSubview($0)
        }
        [menuView, darkView].forEach {
            plusbigView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        dateBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(18)
        }
                
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(8)
        }
        
        bellImg.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalTo(infoLabel)
            make.trailing.equalTo(infoLabel.snp.leading).offset(-4)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(textView.snp.top)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).inset(14)
            make.size.equalTo(20)
            make.centerY.equalTo(textView)
        }
        
        plusbigView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        menuView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(72)
        }
        
        darkView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
