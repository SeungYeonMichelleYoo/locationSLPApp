//
//  DetailProfileView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class DetailProfileView: BaseView {
            
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        view.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableTableViewCell")
        view.register(FixedTableViewCell.self, forCellReuseIdentifier: "FixedTableViewCell")
        view.showsVerticalScrollIndicator = false
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
