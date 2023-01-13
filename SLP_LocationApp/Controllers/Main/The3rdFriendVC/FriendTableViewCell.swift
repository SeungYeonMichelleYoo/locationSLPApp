//
//  FriendTableViewCell.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/07.
//
import UIKit
import SnapKit
import RxSwift

class FriendTableViewCell: UITableViewCell {
    static let identifier = "FriendTableViewCell"
    
    private let onChatChanged: (String) -> Void // 채팅 내용 바뀜
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<Friend>
    let onChanged: Observable<String>
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.image = UIImage(named:"profile_img")
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "고래밥"
        label.textColor = .black
        label.font = UIFont.font(.Title3_M14)
        return label
    }()
    
    lazy var studyLabel: UILabel = {
        let label = UILabel()
        label.text = "농구"
        label.textColor = Constants.BaseColor.green
        label.font = UIFont.font(.Title6_R12)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "22.01.12"
        label.textColor = Constants.BaseColor.gray7
        label.font = UIFont.font(.Body4_R12)
        return label
    }()
    
    lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.text = "왜요? 요즘 코딩이 대세인데"
        label.textColor = .black
        label.font = UIFont.font(.Body3_R14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
      let data = PublishSubject<Friend>()
        let changing = PublishSubject<String>()
        onChatChanged = { changing.onNext($0) }
        
        onData = data.asObserver()
        onChanged = changing
        
        super.init(coder: aDecoder)
        
        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] friend in
                self?.image.image = SesacFace.image(level: friend.image)
                self?.nameLabel.text = friend.matchedNick
                self?.studyLabel.text = friend.study
                self?.chatLabel.text = friend.chat
                self?.dateLabel.text = friend.date
            })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func layout() {
        self.contentView.backgroundColor = .white
        
        [image, nameLabel, studyLabel, dateLabel, chatLabel].forEach {
            contentView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
    
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(image.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        
        studyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(nameLabel.snp.trailing).offset(6)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(image.snp.trailing).offset(8)
        }
        
    }
}
