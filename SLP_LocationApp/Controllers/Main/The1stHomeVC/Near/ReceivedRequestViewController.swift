//
//  ReceivedRequestViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//

import UIKit

class ReceivedRequestViewController: BaseViewController {
    
    var mainView = ReceivedRequestView()
    var receivedList: [OpponentModel] = []
 
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    func toggleBtns(hidden: Bool) {
        mainView.refreshBtn.isHidden = hidden
        mainView.changeBtn.isHidden = hidden
    }
}
