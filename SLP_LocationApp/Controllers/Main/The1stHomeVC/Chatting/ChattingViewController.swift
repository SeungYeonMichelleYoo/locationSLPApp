//
//  ChattingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit

class ChattingViewController: BaseViewController {
    
    var mainView = ChattingView()
 
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreBtnClicked() {
        
    }
}
