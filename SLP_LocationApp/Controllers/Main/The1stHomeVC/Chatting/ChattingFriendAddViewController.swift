//
//  ChattingFriendAddViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/22.
//
import UIKit

final class ChattingFriendAddViewController: BaseViewController {
    
    var mainView = ChattingFriendAddView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
