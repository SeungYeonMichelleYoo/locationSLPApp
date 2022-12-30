//
//  MyInfoView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class MyInfoView: BaseView {
    
    lazy var mainTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        view.register(NameTableViewCell.self, forCellReuseIdentifier: "NameTableViewCell")
        view.register(MyInfoTableViewCell.self, forCellReuseIdentifier: "MyInfoTableViewCell")
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
        [mainTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
