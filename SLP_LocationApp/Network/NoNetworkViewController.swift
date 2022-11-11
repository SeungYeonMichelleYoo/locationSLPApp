//
//  NoNetworkViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/11.
//

import UIKit
import SnapKit

class NoNetworkViewController: BaseViewController {
    
    var mainView = OnboardingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
    }
}
