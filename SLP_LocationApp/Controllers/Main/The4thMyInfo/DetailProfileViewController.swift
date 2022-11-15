//
//  DetailProfileViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit
import SnapKit

class DetailProfileViewController: BaseViewController {
    
    var mainView = DetailProfileView()
    
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
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func saveBtnClicked() {
        
    }
    
}
