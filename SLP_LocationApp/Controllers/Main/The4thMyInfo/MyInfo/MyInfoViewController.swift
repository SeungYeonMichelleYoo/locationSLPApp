//
//  MyInfoViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit

final class MyInfoViewController: BaseViewController {
    
    var mainView = MyInfoView()
        
    let titleName = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "이용약관"]
    let iconName = ["notice", "faq", "qna", "setting_alarm", "permit"]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as! NameTableViewCell
            cell.titleLabel.text = "김새싹"
            return cell
        case 1...5: let cell = tableView.dequeueReusableCell(withIdentifier: "MyInfoTableViewCell", for: indexPath) as! MyInfoTableViewCell
            cell.titleLabel.text = titleName[indexPath.row - 1]
            cell.image.image = UIImage(named: "\(iconName[indexPath.row - 1])")
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 96
        } else {
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = DetailProfileViewController()
            self.transition(vc, transitionStyle: .push)
        }
    }
    
}
