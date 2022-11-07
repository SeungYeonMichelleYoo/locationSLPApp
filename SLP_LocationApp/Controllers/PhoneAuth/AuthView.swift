//
//  AuthView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class AuthView: BaseView {
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
