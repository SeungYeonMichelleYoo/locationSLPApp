//
//  DetailProfileViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit

//크게 2행으로 구성
//expandabletableviewcell, fixedtableviewcell
//expandabletableviewcell: 셀 클릭시 UIView 펼쳐지게 (UIView show, hide)

// var is_hidden = true
// ~~~ .isHidden = is_hidden
// is_hidden = !is_hidden

class DetailProfileViewController: BaseViewController {
    
    var mainView = DetailProfileView()
    var buttonTitle = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    var is_hidden = true
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        navigationItem.title = "정보 관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        setupTableview()
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func saveBtnClicked() {
        
    }
    func setupTableview() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension DetailProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableviewrow")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell", for: indexPath) as! ExpandableTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
            cell.expandableView.isHidden = is_hidden
            cell.selectionStyle = .none
            
            cell.downBtn.setImage(UIImage(systemName: is_hidden ? "chevron.down" : "chevron.up"), for: .normal)
            return cell
            
        case 2: let cell = tableView.dequeueReusableCell(withIdentifier: "FixedTableViewCell", for: indexPath) as! FixedTableViewCell
            cell.selectionStyle = .none //클릭시 배경색상 없애기
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            is_hidden = !is_hidden
            mainView.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        case 1:
            if (is_hidden) {
                return 60
            } else {
                return 400
            }
        case 2:
            return 400
        default: return 100
        }
    }
}

extension DetailProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleBtn.setTitle("\(buttonTitle[indexPath.item])", for: .normal)
        
        return cell
    }
}
