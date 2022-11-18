//
//  DetailProfileView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class DetailProfileView: BaseView {
        
    lazy var bannerImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "cardview_bg")
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        view.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableTableViewCell")
        view.register(FixedTableViewCell.self, forCellReuseIdentifier: "FixedTableViewCell")
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [bannerImg, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        bannerImg.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bannerImg.snp.bottom)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
