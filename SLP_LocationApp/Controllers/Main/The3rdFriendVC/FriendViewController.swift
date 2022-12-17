//
//  FriendViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

class FriendViewController: BaseViewController {
    
    var mainView = FriendView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "friends_plus"), style: .plain, target: self, action: #selector(plusBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.black
    }
    @objc func plusBtnClicked() {
        
    }
   
}
