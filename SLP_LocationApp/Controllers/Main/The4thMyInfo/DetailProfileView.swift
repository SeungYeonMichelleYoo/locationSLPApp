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
        view.image = UIImage(named: "cardview_bg")
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        view.register(NameTableViewCell.self, forCellReuseIdentifier: "NameTableViewCell")
        return view
      }()
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "내 성별"
        label.textColor = Constants.BaseColor.green
        label.font = UIFont.font(.Title4_R14)
        return label
    }()
    
    lazy var maleBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "femaleButton"), for: .normal)
        return view
    }()
    
    lazy var femaleBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "femaleButton"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [bannerImg].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        bannerImg.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(228)
        }
    }
}
