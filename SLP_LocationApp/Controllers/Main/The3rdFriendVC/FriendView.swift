//
//  FriendView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class FriendView: BaseView {
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.attributedPlaceholder = NSAttributedString(string: "새싹친구를 검색해보세요", attributes: [.foregroundColor: Constants.BaseColor.gray6])
        view.backgroundColor = Constants.BaseColor.gray1
        view.font = UIFont.font(.Title4_R14)
        view.leftViewMode = UITextField.ViewMode.always
        let txtfieldLeftView = UIView(frame: CGRect(x: 5, y: 0, width: 35, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        let image = UIImage(named: "magnifyingglass")
        imageView.image = image
        imageView.image = image
        txtfieldLeftView.addSubview(imageView)
        view.leftView = txtfieldLeftView
        view.returnKeyType = UIReturnKeyType.done
        return view
    }()

    lazy var mainTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [textField, mainTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(36)
        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
